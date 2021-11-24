defmodule AuditorActivity.UserSettings do
  import Ecto.Query, warn: false
  alias AuditorActivity.Repo
  alias Ecto.Multi
  alias AuditorActivity.Generic.{User, UserProject, UserTask, UserSkill}

  def list_users(offset \\ 0, limit \\ 10, sort \\ "first_name", order \\ "asc", search \\ "") do
    limit =
      case limit do
        "all" -> User |> select(count("*")) |> Repo.one()
        _ -> limit
      end

    User
    |> order_by({^String.to_atom(order), ^String.to_atom(sort)})
    |> where(
      [u],
      ilike(u.first_name, ^"%#{search}%") or ilike(u.last_name, ^"%#{search}%") or
        ilike(u.email, ^"%#{search}%")
    )
    |> Repo.paginate(page: offset, page_size: limit)
  end

  def get_user!(id) do
    User
    |> preload([:skills, :teams, :tasks])
    |> Repo.get!(id)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    |> user_projects(attrs)
    |> user_projects_for_csv(attrs)
    |> user_tasks(attrs)
    |> user_tasks_for_csv(attrs)
    |> user_skills(attrs)
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
    |> user_projects(attrs)
    |> user_projects_for_csv(attrs)
    |> user_tasks(attrs)
    |> user_tasks_for_csv(attrs)
    |> user_skills(attrs)
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def activate_user(user) do
    attrs = %{active_status: true}

    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def deactivate_user(user) do
    attrs = %{active_status: false}

    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def user_projects(response, attrs) do
    case {response, Map.has_key?(attrs, "projects")} do
      {{:ok, user_instance}, true} ->
        case make_relation_with_user_and_projects(
               user_instance.id,
               Map.get(attrs, "projects")
             ) do
          {:ok, _} -> {:ok, Repo.preload(user_instance, [:projects])}
          error_response -> error_response
        end

      _ ->
        response
    end
  end

  def user_projects_for_csv(response, attrs) do
    case {response, Map.has_key?(attrs, :projects)} do
      {{:ok, user_instance}, true} ->
        case make_relation_with_user_and_projects(
               user_instance.id,
               Map.get(attrs, :projects)
             ) do
          {:ok, _} -> {:ok, Repo.preload(user_instance, [:projects])}
          error_response -> error_response
        end

      _ ->
        response
    end
  end

  def make_relation_with_user_and_projects(user_id, project_ids) do
    user_projects =
      project_ids
      |> Enum.uniq()
      |> Enum.map(fn project_id ->
        %{
          user_id: user_id,
          project_id: project_id
        }
      end)

    multi =
      Multi.new()
      |> Multi.delete_all(
        :delete_all,
        UserProject |> where([up], up.user_id == ^user_id)
      )
      |> Multi.insert_all(:insert_all, UserProject, user_projects)

    case Repo.transaction(multi) do
      {:ok, _multi_result} ->
        {:ok, :updated}

      {:error, changeset} ->
        {:error, changeset}

      {:error, _, changeset, _} ->
        {:error, changeset}
    end
  end

  def user_tasks(response, attrs) do
    case {response, Map.has_key?(attrs, "tasks")} do
      {{:ok, user_instance}, true} ->
        case make_relation_with_user_and_tasks(
               user_instance.id,
               Map.get(attrs, "tasks")
             ) do
          {:ok, _} -> {:ok, Repo.preload(user_instance, [:tasks])}
          error_response -> error_response
        end

      _ ->
        response
    end
  end

  def user_tasks_for_csv(response, attrs) do
    case {response, Map.has_key?(attrs, :tasks)} do
      {{:ok, user_instance}, true} ->
        case make_relation_with_user_and_tasks(
               user_instance.id,
               Map.get(attrs, :tasks)
             ) do
          {:ok, _} -> {:ok, Repo.preload(user_instance, [:tasks])}
          error_response -> error_response
        end

      _ ->
        response
    end
  end

  def make_relation_with_user_and_tasks(user_id, task_ids) do
    user_tasks =
      task_ids
      |> Enum.uniq()
      |> Enum.map(fn task_id ->
        %{
          user_id: user_id,
          task_id: task_id
        }
      end)

    multi =
      Multi.new()
      |> Multi.delete_all(
        :delete_all,
        UserTask |> where([up], up.user_id == ^user_id)
      )
      |> Multi.insert_all(:insert_all, UserTask, user_tasks)

    case Repo.transaction(multi) do
      {:ok, _multi_result} ->
        {:ok, :updated}

      {:error, changeset} ->
        {:error, changeset}

      {:error, _, changeset, _} ->
        {:error, changeset}
    end
  end

  def user_skills(response, attrs) do
    case {response, Map.has_key?(attrs, "skills")} do
      {{:ok, user_instance}, true} ->
        case make_relation_with_user_and_skills(
               user_instance.id,
               Map.get(attrs, "skills")
             ) do
          {:ok, _} -> {:ok, Repo.preload(user_instance, [:skills])}
          error_response -> error_response
        end

      _ ->
        response
    end
  end

  def make_relation_with_user_and_skills(user_id, skill_ids) do
    user_skills =
      skill_ids
      |> Enum.uniq()
      |> Enum.map(fn skill_id ->
        %{
          user_id: user_id,
          skill_id: skill_id
        }
      end)

    multi =
      Multi.new()
      |> Multi.delete_all(
        :delete_all,
        UserSkill |> where([up], up.user_id == ^user_id)
      )
      |> Multi.insert_all(:insert_all, UserSkill, user_skills)

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
