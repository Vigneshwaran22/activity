defmodule AuditorActivity.TaskSettings do
  import Ecto.Query, warn: false
  alias AuditorActivity.Repo
  import Ecto.Changeset

  alias Ecto.Multi

  alias AuditorActivity.Generic.Checklist

  @doc """
  Returns the list of checklists.

  ## Examples

      iex> list_checklists()
      [%Checklist{}, ...]

  """
  def list_checklists(offset \\ 0, limit \\ 10, sort \\ "name", order \\ "asc", search \\ "") do
    limit =
      case limit do
        "all" -> Checklist |> select(count("*")) |> Repo.one()
        _ -> limit
      end

    Checklist
    |> order_by({^String.to_atom(order), ^String.to_atom(sort)})
    |> where([u], ilike(u.name, ^"%#{search}%") or ilike(u.description, ^"%#{search}%"))
    |> preload(:checkpoints)
    |> Repo.paginate(page: offset, page_size: limit)
  end

  @doc """
  Gets a single checklist.

  Raises `Ecto.NoResultsError` if the Check list does not exist.

  ## Examples

      iex> get_checklist!(123)
      %Checklist{}

      iex> get_checklist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_checklist!(id), do: Repo.get!(Checklist, id) |> Repo.preload(:checkpoints)

  @doc """
  Creates a checklist.

  ## Examples

      iex> create_checklist(%{field: value})
      {:ok, %Checklist{}}

      iex> create_checklist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_checklist(attrs \\ %{}) do
    %Checklist{}
    |> Checklist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a checklist.

  ## Examples

      iex> update_checklist(checklist, %{field: new_value})
      {:ok, %Checklist{}}

      iex> update_checklist(checklist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_checklist(%Checklist{} = checklist, attrs) do
    checklist
    |> Checklist.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a checklist.

  ## Examples

      iex> delete_checklist(checklist)
      {:ok, %Checklist{}}

      iex> delete_checklist(checklist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_checklist(%Checklist{} = checklist) do
    Repo.delete(checklist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking checklist changes.

  ## Examples

      iex> change_checklist(checklist)
      %Ecto.Changeset{source: %Checklist{}}

  """
  def change_checklist(%Checklist{} = checklist) do
    Checklist.changeset(checklist, %{})
  end

  alias AuditorActivity.Generic.Checkpoint

  @doc """
  Returns the list of checkpoints.

  ## Examples

      iex> list_checkpoints()
      [%Checkpoint{}, ...]

  """
  def list_checkpoints do
    Repo.all(Checkpoint)
  end

  @doc """
  Gets a single checkpoint.

  Raises `Ecto.NoResultsError` if the Check point does not exist.

  ## Examples

      iex> get_checkpoint!(123)
      %Checkpoint{}

      iex> get_checkpoint!(456)
      ** (Ecto.NoResultsError)

  """
  def get_checkpoint!(id), do: Repo.get!(Checkpoint, id)

  @doc """
  Creates a checkpoint.

  ## Examples

      iex> create_checkpoint(%{field: value})
      {:ok, %Checkpoint{}}

      iex> create_checkpoint(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_checkpoint(attrs \\ %{}) do
    %Checkpoint{}
    |> Checkpoint.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a checkpoint.

  ## Examples

      iex> update_checkpoint(checkpoint, %{field: new_value})
      {:ok, %Checkpoint{}}

      iex> update_checkpoint(checkpoint, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_checkpoint(%Checkpoint{} = checkpoint, attrs) do
    checkpoint
    |> Checkpoint.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a checkpoint.

  ## Examples

      iex> delete_checkpoint(checkpoint)
      {:ok, %Checkpoint{}}

      iex> delete_checkpoint(checkpoint)
      {:error, %Ecto.Changeset{}}

  """
  def delete_checkpoint(%Checkpoint{} = checkpoint) do
    Repo.delete(checkpoint)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking checkpoint changes.

  ## Examples

      iex> change_checkpoint(checkpoint)
      %Ecto.Changeset{source: %Checkpoint{}}

  """
  def change_checkpoint(%Checkpoint{} = checkpoint) do
    Checkpoint.changeset(checkpoint, %{})
  end

  alias AuditorActivity.Generic.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """

  def list_tasks(offset \\ 0, limit \\ 10, sort \\ "name", order \\ "asc", search \\ "") do
    limit =
      case limit do
        "all" -> Task |> select(count("*")) |> Repo.one()
        _ -> limit
      end

    Task
    |> order_by({^String.to_atom(order), ^String.to_atom(sort)})
    |> where([u], ilike(u.name, ^"%#{search}%") or ilike(u.description, ^"%#{search}%") or ilike(u.type, ^"%#{search}%"))
    |> preload([:checklists, checklists: :checkpoints])
    |> Repo.paginate(page: offset, page_size: limit)
  end

  def get_checklist_by_id(id) do
    Checklist
    |> where(task_id: ^id)
    |> Repo.all()
    |> Enum.map(fn x ->
      %{
        id: x.id,
        name: x.name,
        description: x.description,
        checkpoints: get_checkpoint_by_id(x.id)
      }
    end)
  end

  def get_checkpoint_by_id(id) do
    Checkpoint
    |> where(checklist_id: ^id)
    |> Repo.all()
    |> Enum.map(fn x ->
      %{
        id: x.id,
        name: x.name,
        type: x.type,
        options: x.options,
        sub_type: x.sub_type
      }
    end)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id) do
    Repo.get!(Task, id) |> Repo.preload([:checklists, checklists: :checkpoints])
    # task_list = Repo.get!(Task, id)

    # check_list = get_checklist_by_id(task_list.id)
    # %{
    #   description: task_list.description,
    #   id: task_list.id,
    #   inserted_at: task_list.inserted_at,
    #   name: task_list.name,
    #   updated_at: task_list.updated_at,
    #   checklists: check_list
    # }
  end

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
    |> task_project_types(attrs)
    |> task_project_types_for_csv(attrs)
    |> task_users(attrs)
    |> task_users_for_csv(attrs)
    # |> task_checklists(attrs)
    # |> task_checklists_for_csv(attrs)
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
    |> task_project_types(attrs)
    |> task_project_types_for_csv(attrs)
    |> task_users(attrs)
    |> task_users_for_csv(attrs)
    # |> task_checklists(attrs)
    # |> task_checklists_for_csv(attrs)
  end

  def update_status(%Task{} = task, attrs) do
    response =
      task
      |> Task.changeset(attrs)
      |> Repo.update()

    case {response, Map.has_key?(attrs, "project_types")} do
      {{:ok, updated_task}, true} ->
        case make_relation_with_task_and_projecttypes(
               updated_task.id,
               Map.get(attrs, "project_types")
             ) do
          {:ok, _} -> {:ok, Repo.preload(updated_task, [:project_types])}
          error_response -> error_response
        end

      _ ->
        response
    end
  end

  # def update_status1(%Task{} = task, attrs) do
  #   response =
  #     task
  #     |> Task.changeset(attrs)
  #     |> Repo.update()

  #   case {response, Map.has_key?(attrs, :project_types)} do
  #     {{:ok, updated_task}, true} ->
  #       case make_relation_with_task_and_projecttypes(
  #              updated_task.id,
  #              Map.get(attrs, :project_types)
  #            ) do
  #         {:ok, _} -> {:ok, Repo.preload(updated_task, [:project_types])}
  #         error_response -> error_response
  #       end

  #     _ ->
  #       response
  #   end
  # end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{source: %Task{}}

  """
  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end

  def change_task_status(task, task_params) do
    task_status = Map.get(task_params, "status")
    time_now = DateTime.utc_now()

    case {task.status, task_status} do
      {"Not Started", "Started"} ->
        update_task(task, Map.put_new(task_params, "started_on", time_now))

      {"Started", "Completed"} ->
        update_task(task, Map.put_new(task_params, "completed_on", time_now))

      {_, _} ->
        cs =
          Task.changeset(%Task{}, Map.from_struct(task))
          |> add_error(:status, "Unable to update status")

        {:error, cs}
    end
  end

  alias AuditorActivity.Generic.ChecklistTask

  def task_checklists(response, attrs) do
    case {response, Map.has_key?(attrs, "checklists")} do
      {{:ok, task_instance}, true} ->
        case make_relation_with_task_and_checklists(
               task_instance.id,
               Map.get(attrs, "checklists")
             ) do
          {:ok, _} -> {:ok, Repo.preload(task_instance, [:checklists])}
          error_response -> error_response
        end

      _ ->
        response
    end
  end

  def task_checklists_for_csv(response, attrs) do
    case {response, Map.has_key?(attrs, :checklists)} do
      {{:ok, task_instance}, true} ->
        case make_relation_with_task_and_checklists(
               task_instance.id,
               Map.get(attrs, :checklists)
             ) do
          {:ok, _} -> {:ok, Repo.preload(task_instance, [:checklists])}
          error_response -> error_response
        end

      _ ->
        response
    end
  end

  def make_relation_with_task_and_checklists(task_id, checklist_ids) do
    task_checklists =
      checklist_ids
      |> Enum.uniq()
      |> Enum.map(fn checklist_id ->
        %{
          checklist_id: checklist_id,
          task_id: task_id
        }
      end)

    multi =
      Multi.new()
      |> Multi.delete_all(
        :delete_all,
        ChecklistTask |> where([ut], ut.task_id == ^task_id)
      )
      |> Multi.insert_all(:insert_all, ChecklistTask, task_checklists)

    case Repo.transaction(multi) do
      {:ok, _multi_result} ->
        {:ok, :updated}

      {:error, changeset} ->
        {:error, changeset}

      {:error, _, changeset, _} ->
        {:error, changeset}
    end
  end

  alias AuditorActivity.Generic.UserTask

  def task_users(response, attrs) do
    case {response, Map.has_key?(attrs, "users")} do
      {{:ok, task_instance}, true} ->
        case make_relation_with_task_and_users(
               task_instance.id,
               Map.get(attrs, "users")
             ) do
          {:ok, _} -> {:ok, Repo.preload(task_instance, [:users])}
          error_response -> error_response
        end

      _ ->
        response
    end
  end

  def task_users_for_csv(response, attrs) do
    case {response, Map.has_key?(attrs, :users)} do
      {{:ok, task_instance}, true} ->
        case make_relation_with_task_and_users(
               task_instance.id,
               Map.get(attrs, :users)
             ) do
          {:ok, _} -> {:ok, Repo.preload(task_instance, [:users])}
          error_response -> error_response
        end

      _ ->
        response
    end
  end

  def make_relation_with_task_and_users(task_id, user_ids) do
    task_users =
      user_ids
      |> Enum.uniq()
      |> Enum.map(fn user_id ->
        %{
          user_id: user_id,
          task_id: task_id
        }
      end)

    multi =
      Multi.new()
      |> Multi.delete_all(
        :delete_all,
        UserTask |> where([ut], ut.task_id == ^task_id)
      )
      |> Multi.insert_all(:insert_all, UserTask, task_users)

    case Repo.transaction(multi) do
      {:ok, _multi_result} ->
        {:ok, :updated}

      {:error, changeset} ->
        {:error, changeset}

      {:error, _, changeset, _} ->
        {:error, changeset}
    end
  end

  alias AuditorActivity.Generic.ProjecttypeTask

  def task_project_types(response, attrs) do
    case {response, Map.has_key?(attrs, "project_types")} do
      {{:ok, task_instance}, true} ->
        case make_relation_with_task_and_projecttypes(
               task_instance.id,
               Map.get(attrs, "project_types")
             ) do
          {:ok, _} -> {:ok, Repo.preload(task_instance, [:project_types])}
          error_response -> error_response
        end

      _ ->
        response
    end
  end

  def task_project_types_for_csv(response, attrs) do
    case {response, Map.has_key?(attrs, :project_types)} do
      {{:ok, task_instance}, true} ->
        case make_relation_with_task_and_projecttypes(
               task_instance.id,
               Map.get(attrs, :project_types)
             ) do
          {:ok, _} -> {:ok, Repo.preload(task_instance, [:project_types])}
          error_response -> error_response
        end

      _ ->
        response
    end
  end

  def make_relation_with_task_and_projecttypes(task_id, project_type_ids) do
    task_projects =
      project_type_ids
      |> Enum.uniq()
      |> Enum.map(fn project_type_id ->
        %{
          task_id: task_id,
          project_type_id: project_type_id
        }
      end)

    multi =
      Multi.new()
      |> Multi.delete_all(:delete_all, ProjecttypeTask |> where([pt], pt.task_id == ^task_id))
      |> Multi.insert_all(:insert_all, ProjecttypeTask, task_projects)

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
