defmodule AuditorActivity.TeamSettings do
  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias AuditorActivity.Repo
  alias Ecto.Multi

  alias AuditorActivity.Generic.{TeamTemplate, Team, TeamUser, TeamSkill}

  @doc """
  Returns the list of team_templates.

  ## Examples

      iex> list_team_templates()
      [%TeamTemplate{}, ...]

  """
  def list_team_templates(offset \\ 0, limit \\ 10, sort \\ "name", order \\ "asc", search \\ "") do
    limit =
      case limit do
        "all" -> TeamTemplate |> select(count("*")) |> Repo.one()
        _ -> limit
      end

    TeamTemplate
    |> order_by({^String.to_atom(order), ^String.to_atom(sort)})
    |> where([tt], ilike(tt.name, ^"%#{search}%") or ilike(tt.description, ^"%#{search}%"))
    |> Repo.paginate(page: offset, page_size: limit)
  end

  @doc """
  Gets a single team_template.

  Raises `Ecto.NoResultsError` if the Team template does not exist.

  ## Examples

      iex> get_team_template!(123)
      %TeamTemplate{}

      iex> get_team_template!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team_template!(id), do: Repo.get!(TeamTemplate, id)

  @doc """
  Creates a team_template.

  ## Examples

      iex> create_team_template(%{field: value})
      {:ok, %TeamTemplate{}}

      iex> create_team_template(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team_template(attrs \\ %{}) do
    %TeamTemplate{}
    |> TeamTemplate.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team_template.

  ## Examples

      iex> update_team_template(team_template, %{field: new_value})
      {:ok, %TeamTemplate{}}

      iex> update_team_template(team_template, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team_template(%TeamTemplate{} = team_template, attrs) do
    team_template
    |> TeamTemplate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team_template.

  ## Examples

      iex> delete_team_template(team_template)
      {:ok, %TeamTemplate{}}

      iex> delete_team_template(team_template)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team_template(%TeamTemplate{} = team_template) do
    Repo.delete(team_template)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team_template changes.

  ## Examples

      iex> change_team_template(team_template)
      %Ecto.Changeset{source: %TeamTemplate{}}

  """
  def change_team_template(%TeamTemplate{} = team_template) do
    TeamTemplate.changeset(team_template, %{})
  end

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(Team)
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id), do: Repo.get!(Team, id)

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
    |> team_users(attrs)
    |> team_skills(attrs)
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
    |> team_users(attrs)
    |> team_skills(attrs)
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{source: %Team{}}

  """
  def change_team(%Team{} = team) do
    Team.changeset(team, %{})
  end

  defp team_users(response, attrs) do
    case {response, Map.has_key?(attrs, "users")} do
      {{:ok, team_instance}, true} ->
        case make_relation_with_team_and_users(
               team_instance.id,
               Map.get(attrs, "users")
             ) do
          {:ok, _} -> {:ok, team_instance}
          error_response -> error_response
        end

      _ ->
        response
    end
  end

  defp make_relation_with_team_and_users(team_id, user_ids) do
    team_users =
      user_ids
      |> Enum.uniq()
      |> Enum.map(fn user_id ->
        %{
          user_id: user_id,
          team_id: team_id
        }
      end)

    multi =
      Multi.new()
      |> Multi.delete_all(
        :delete_all,
        TeamUser |> where([tu], tu.team_id == ^team_id)
      )
      |> Multi.insert_all(:insert_all, TeamUser, team_users)

    case Repo.transaction(multi) do
      {:ok, _multi_result} ->
        {:ok, :updated}

      {:error, changeset} ->
        {:error, changeset}

      {:error, _, changeset, _} ->
        {:error, changeset}
    end
  end

  defp team_skills(response, attrs) do
    case {response, Map.has_key?(attrs, "skills")} do
      {{:ok, team_instance}, true} ->
        case make_relation_with_team_and_skills(
               team_instance.id,
               Map.get(attrs, "skills")
             ) do
          {:ok, _} -> {:ok, team_instance}
          error_response -> error_response
        end

      _ ->
        response
    end
  end

  defp make_relation_with_team_and_skills(team_id, skill_ids) do
    team_skills =
      skill_ids
      |> Enum.uniq()
      |> Enum.map(fn skill_id ->
        %{
          skill_id: skill_id,
          team_id: team_id
        }
      end)

    multi =
      Multi.new()
      |> Multi.delete_all(
        :delete_all,
        TeamSkill |> where([ts], ts.team_id == ^team_id)
      )
      |> Multi.insert_all(:insert_all, TeamSkill, team_skills)

    case Repo.transaction(multi) do
      {:ok, _multi_result} ->
        {:ok, :updated}

      {:error, changeset} ->
        {:error, changeset}

      {:error, _, changeset, _} ->
        {:error, changeset}
    end
  end
end
