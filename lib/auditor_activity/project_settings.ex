defmodule AuditorActivity.ProjectSettings do
  import Ecto.Query, warn: false
  alias AuditorActivity.Repo

  alias Ecto.Multi

  # import Ecto.Changeset

  alias AuditorActivity.Generic.ProjectType

  @doc """
  Returns the list of project_types.

  ## Examples

      iex> list_project_types()
      [%ProjectType{}, ...]

  """
  def list_project_types(offset \\ 0, limit \\ 10, sort \\ "name", order \\ "asc", search \\ "") do
    limit =
      case limit do
        "all" -> ProjectType |> select(count("*")) |> Repo.one()
        _ -> limit
      end

    ProjectType
    |> join(:left, [pt], ec in assoc(pt, :equipment_category))
    |> where([pt, ec], pt.equipment_category_id == ec.id)
    |> where([pt, ec], ilike(pt.name, ^"%#{search}%")  or ilike(pt.description, ^"%#{search}%") or ilike(ec.name, ^"%#{search}%"))
    |> select([pt, ec], %{id: pt.id, name: pt.name, equipment_category: ec.name})
    |> project_type_list_order_by_field(order, sort)
    |> Repo.paginate(page: offset, page_size: limit)
  end

  defp project_type_list_order_by_field(query, order, sort) do
    case {order, sort} do
      {"asc", "equipment_category"} -> query |> order_by([pt, ec], asc: ec.name)
      {"desc", "equipment_category"} -> query |> order_by([pt, ec], desc: ec.name)
      {_, _} -> query |> order_by({^String.to_atom(order), ^String.to_atom(sort)})
    end
  end

  @doc """
  Gets a single project_type.

  Raises `Ecto.NoResultsError` if the Project type does not exist.

  ## Examples

      iex> get_project_type!(123)
      %ProjectType{}

      iex> get_project_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project_type_id!(id) do
    ProjectType |> preload([:tasks, tasks: :checklists]) |> Repo.get!(id)
  end

  def get_project_type!(id) do
    pt =
      ProjectType
      |> preload([:equipment_category, :tasks, tasks: :checklists])
      |> Repo.get!(id)

    list = change_tasks_list_by_id(pt)
    IO.inspect(Map.put(pt, :tasks, list))
  end

  @doc """
  Creates a project_type.

  ## Examples

      iex> create_project_type(%{field: value})
      {:ok, %ProjectType{}}

      iex> create_project_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project_type(attrs \\ %{}) do
    %ProjectType{}
    |> ProjectType.changeset(attrs)
    |> Repo.insert()
    |> project_tasks(attrs)
    |> project_tasks_for_csv(attrs)
  end

  @doc """
  Updates a project_type.

  ## Examples

      iex> update_project_type(project_type, %{field: new_value})
      {:ok, %ProjectType{}}

      iex> update_project_type(project_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project_type(%ProjectType{} = project_type, attrs) do
    # changes_attrs = change_tasks_list_by_id(attrs)
    IO.inspect "update_project_type"
    IO.inspect project_type
    # IO.inspect "attrs"
    # IO.inspect attrs
    # IO.inspect "changes_attrs"
    # IO.inspect changes_attrs
    # Map.put(attrs, "tasks", changes_attrs)
    # IO.inspect "attrs"
    # IO.inspect attrs
    project_type
    # |> change_tasks_by_id()
    |> ProjectType.changeset(attrs)
    |> Repo.update()
    # |> change_tasks_by_id()
    |> project_tasks(attrs)
    |> project_tasks_for_csv(attrs)
  end

  defp change_tasks_list_by_id(cs) do
    IO.inspect(cs)
    tasks_list = cs.tasks
    IO.inspect("tasks_list")
    IO.inspect(tasks_list)

    tasks_list
    |> Enum.map(fn x -> IO.inspect(x.id) end)

    # lists = Enum.map(tasks_list, & &1["id"])
    # IO.inspect lists
    # put_change(cs, :tasks, tasks_list)
    # IO.inspect tasks_list
  end

  @doc """
  Deletes a project_type.

  ## Examples

      iex> delete_project_type(project_type)
      {:ok, %ProjectType{}}

      iex> delete_project_type(project_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project_type(%ProjectType{} = project_type) do
    Repo.delete(project_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project_type changes.

  ## Examples

      iex> change_project_type(project_type)
      %Ecto.Changeset{source: %ProjectType{}}

  """
  def change_project_type(%ProjectType{} = project_type) do
    ProjectType.changeset(project_type, %{})
  end

  alias AuditorActivity.Generic.ProjecttypeTask

  def project_tasks(response, attrs) do
    case {response, Map.has_key?(attrs, "tasks")} do
      {{:ok, project_instance}, true} ->
        case make_relation_with_projecttype_and_task(
               project_instance.id,
               Map.get(attrs, "tasks")
             ) do
          {:ok, _} -> {:ok, Repo.preload(project_instance, [:tasks])}
          error_response -> error_response
        end

      _ ->
        response
    end
  end

  def project_tasks_for_csv(response, attrs) do
    case {response, Map.has_key?(attrs, :tasks)} do
      {{:ok, project_instance}, true} ->
        case make_relation_with_projecttype_and_task(
               project_instance.id,
               Map.get(attrs, :tasks)
             ) do
          {:ok, _} -> {:ok, Repo.preload(project_instance, [:tasks])}
          error_response -> error_response
        end

      _ ->
        response
    end
  end

  def make_relation_with_projecttype_and_task(project_type_id, task_ids) do
    projecttype_tasks =
      task_ids
      |> Enum.uniq()
      |> Enum.map(fn task_id ->
        %{
          task_id: task_id,
          project_type_id: project_type_id
        }
      end)

    multi =
      Multi.new()
      |> Multi.delete_all(
        :delete_all,
        ProjecttypeTask |> where([pt], pt.project_type_id == ^project_type_id)
      )
      |> Multi.insert_all(:insert_all, ProjecttypeTask, projecttype_tasks)

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
