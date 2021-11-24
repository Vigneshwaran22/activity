defmodule AuditorActivity.Projects do
  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias Ecto.Multi
  alias AuditorActivity.Generic.{Project, Checkpoint}
  alias AuditorActivity.{NextWorkOrder, ProjectSettings, Repo}

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects(offset \\ 0, limit \\ 10, sort \\ "name", order \\ "asc", search \\ "") do
    Project
    |> join(:left, [p], e in assoc(p, :equipment))
    |> join(:left, [p], pt in assoc(p, :project_type))
    |> join(:left, [p], tt in assoc(p, :team_template))
    |> where([p, e, pt, tt], p.equipment_id == e.id and p.project_type_id == pt.id)
    |> where([p, e, pt, tt], ilike(p.name, ^"%#{search}%")  or ilike(p.type, ^"%#{search}%") or ilike(p.status, ^"%#{search}%") or ilike(e.brand_name, ^"%#{search}%") or ilike(pt.name, ^"%#{search}%") or ilike(e.variant, ^"%#{search}%") or ilike(tt.name, ^"%#{search}%"))
    |> select([p, e, pt, tt], %{id: p.id, name: p.name, type: p.type, start_date: p.start_date, end_date: p.end_date, status: p.status, equipment: fragment("concat(?, ' - ', ?)", e.brand_name, e.variant), project_type: pt.name, team_template: tt.name})
    |> project_list_order_by_field(order, sort)
    |> Repo.paginate(page: offset, page_size: limit)
  end

  defp project_list_order_by_field(query, order, sort) do
    case {order, sort} do
      {"asc", "equipment"} -> query |> order_by([p, e, pt, tt], asc: e.brand_name)
      {"desc", "equipment"} -> query |> order_by([p, e, pt, tt], desc: e.brand_name)
      {"asc", "project_type"} -> query |> order_by([p, e, pt, tt], asc: pt.name)
      {"desc", "project_type"} -> query |> order_by([p, e, pt, tt], desc: pt.name)
      {"asc", "team_template"} -> query |> order_by([p, e, pt, tt], asc: e.brand_name)
      {"desc", "team_template"} -> query |> order_by([p, e, pt, tt], desc: e.brand_name)
      {_, _} -> query |> order_by({^String.to_atom(order), ^String.to_atom(sort)})
    end
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id) do
    Project
    |> preload([:project_type, :equipment, :users, :team_template])
    # |> preload(:project_type)
    |> Repo.get!(id)
  end

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
    # IO.inspect attrs
    project_instance =
      %Project{}
      |> Project.changeset(attrs)
      |> Repo.insert()
      |> project_users(attrs)
      |> project_users_for_csv(attrs)

    case project_instance do
      {:ok, project} ->
        project_with_work_order_creation(project)
        project_instance

      _ ->
        project_instance
    end
  end

  def get_projects_for_work_order_creation() do
    today_date = Date.utc_today()

    Project
    |> where([p], p.end_date >= ^today_date and p.status in ["Not Started", "Started"])
    |> preload(:project_type)
    |> Repo.all()
    |> Enum.map(fn project ->
      if(
        project.next_workorder_date != nil &&
          Date.compare(project.next_workorder_date, today_date) == :eq
      ) do
        make_work_order_struct(project)
        change_next_order(project)
      end
    end)
  end

  def change_next_order(attrs_map) do
    next_workorder_date = NextWorkOrder.next_work_order(attrs_map.schedule_type, attrs_map)
    # attrs = Map.put(attrs_map, :next_workorder_date, next_workorder_date |> elem(1))
    projects = get_project!(attrs_map.id)
    update_projects(projects, %{next_workorder_date: next_workorder_date |> elem(1)})
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_projects(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
    |> project_users(attrs)
    |> project_users_for_csv(attrs)
  end

  def update_project(%Project{} = project, attrs) do
    # user_list = Map.get(attrs, "users")
    # user_ids = change_users_list(user_list)
    # attrs = Map.put(attrs, "users", user_ids)
    # IO.inspect(user_ids)

    project
    |> Project.changeset(attrs)
    |> Repo.update()
    |> project_users(attrs)
    |> project_users_for_csv(attrs)
  end

  def change_users_list(list) do
    list
    |> Enum.map(fn x -> Map.get(x, "id") end)
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    case project.status do
      "Not Started" -> Repo.delete(project)
      _ -> update_project(project, %{status: "Suspend"})
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{source: %Project{}}

  """
  def change_project(%Project{} = project) do
    Project.changeset(project, %{})
  end

  def change_project_status(project, project_params) do
    project_status = Map.get(project_params, "status")
    time_now = DateTime.utc_now()

    case {project.status, project_status} do
      {"Not Started", "Started"} ->
        update_project(project, Map.put_new(project_params, "started_on", time_now))

      {"Started", "Completed"} ->
        update_project(project, Map.put_new(project_params, "completed_on", time_now))

      {_, _} ->
        cs =
          Project.changeset(%Project{}, Map.from_struct(project))
          |> add_error(:status, "Unable to update status")

        {:error, cs}
    end
  end

  defp project_with_work_order_creation(project) do
    case project.type do
      "Ad hoc" ->
        make_work_order_struct(project)

      _ ->
        next_workorder_date = NextWorkOrder.next_work_order(project.schedule_type, project)
        # dt = DateTime.now("Etc/UTC") |> elem(1)
        # dt1 = DateTime.add(dt, 19800, :second)
        # cdt = DateTime.to_naive(dt1)
        today = NaiveDateTime.utc_now()
        cdt = NaiveDateTime.add(today, 19800)
        IO.inspect Date.compare(cdt, next_workorder_date |> elem(0))
        IO.inspect cdt
        IO.inspect next_workorder_date
        case Date.compare(cdt, next_workorder_date |> elem(0)) do
          :eq ->
            IO.inspect(Time.compare(cdt, next_workorder_date |> elem(0)))

            case Time.compare(cdt, next_workorder_date |> elem(0)) do
              :lt ->
                make_work_order_struct(project)
                change_next_order(project)

              _ ->
                change_next_order(project)
            end

          _ ->
            change_next_order(project)
        end
    end
  end

  def create_date_time(date, time) do
    NaiveDateTime.new(date, time) |> elem(1)
  end

  defp make_work_order_struct(project) do
    IO.inspect project.project_type_id
    %{
      project_id: project.id,
      start_time: project.start_hour,
      work_order_tasks: copy_tasks(ProjectSettings.get_project_type_id!(project.project_type_id))
    }
    |> create_work_order()

    # Enum.reduce(
    #   copy_tasks(ProjectSettings.get_project_type_id!(project.project_type_id)),
    #   [],
    #   fn task_instace, tasks ->
    #     checklist_ids =
    #       Enum.reduce(task_instace.checklists, [], fn checklist_instance, checklists ->
    #         {:ok, checklist} = TaskSettings.create_checklist(checklist_instance)
    #         [checklist.id | checklists]
    #       end)

    #     task_instace = %{
    #       "name" => task_instace.name,
    #       "description" => task_instace.description,
    #       "work_order_id" => work_order.id,
    #       "checklists" => checklist_ids
    #     }

    #     {:ok, task} = TaskSettings.create_task(task_instace)
    #     [task | tasks]
    #   end
    # )
  end

  defp copy_tasks(project_type) do
    Enum.reduce(project_type.tasks, [], fn task, list ->
      [
        %{
          task_id: task.id,
          work_order_checklists:
            Enum.reduce(task.checklists, [], fn checklist, checklists ->
              checkpoint_list = Checkpoint |> where(checklist_id: ^checklist.id) |> Repo.all()

              [
                %{
                  checklist_id: checklist.id,
                  work_order_checkpoints:
                    Enum.reduce(checkpoint_list, [], fn checkpoint, checkpoints ->
                      [%{checkpoint_id: checkpoint.id} | checkpoints]
                    end)
                }
                | checklists
              ]
            end)
        }
        | list
      ]
    end)
  end

  alias AuditorActivity.Generic.UserProject

  def project_users(response, attrs) do
    case {response, Map.has_key?(attrs, "users")} do
      {{:ok, project_instance}, true} ->
        case make_relation_with_project_and_users(
               project_instance.id,
               Map.get(attrs, "users")
             ) do
          {:ok, _} -> {:ok, Repo.preload(project_instance, [:users])}
          error_response -> error_response
        end

      _ ->
        response
    end
  end

  def project_users_for_csv(response, attrs) do
    case {response, Map.has_key?(attrs, :users)} do
      {{:ok, project_instance}, true} ->
        case make_relation_with_project_and_users(
               project_instance.id,
               Map.get(attrs, :users)
             ) do
          {:ok, _} -> {:ok, Repo.preload(project_instance, [:users])}
          error_response -> error_response
        end

      _ ->
        response
    end
  end

  def make_relation_with_project_and_users(project_id, user_ids) do
    project_users =
      user_ids
      |> Enum.uniq()
      |> Enum.map(fn user_id ->
        %{
          user_id: user_id,
          project_id: project_id
        }
      end)

    multi =
      Multi.new()
      |> Multi.delete_all(
        :delete_all,
        UserProject |> where([up], up.project_id == ^project_id)
      )
      |> Multi.insert_all(:insert_all, UserProject, project_users)

    case Repo.transaction(multi) do
      {:ok, _multi_result} ->
        {:ok, :updated}

      {:error, changeset} ->
        {:error, changeset}

      {:error, _, changeset, _} ->
        {:error, changeset}
    end
  end

  alias AuditorActivity.Generic.WorkOrder

  @doc """
  Returns the list of work_orders.

  ## Examples

      iex> list_work_orders()
      [%WorkOrder{}, ...]

  """
  def list_work_orders(offset \\ 0, limit \\ 10, sort \\ "work_order_date", order \\ "asc", search \\ "") do
    WorkOrder
    |> order_by({^String.to_atom(order), ^String.to_atom(sort)})
    |> where([u], ilike(u.name, ^"%#{search}%"))
    |> preload(:project)
    |> preload([:work_order_tasks, work_order_tasks: :task])
    |> Repo.paginate(page: offset, page_size: limit)
  end

  @doc """
  Gets a single work_order.

  Raises `Ecto.NoResultsError` if the Work order does not exist.

  ## Examples

      iex> get_work_order!(123)
      %WorkOrder{}

      iex> get_work_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_work_order!(id) do
    WorkOrder
    |> preload([:project, project: :equipment])
    |> preload([:work_order_tasks, work_order_tasks: :work_order_checklists])
    |> Repo.get!(id)
  end

  @doc """
  Creates a work_order.

  ## Examples

      iex> create_work_order(%{field: value})
      {:ok, %WorkOrder{}}

      iex> create_work_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_work_order(attrs \\ %{}) do
    %WorkOrder{}
    |> WorkOrder.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a work_order.

  ## Examples

      iex> update_work_order(work_order, %{field: new_value})
      {:ok, %WorkOrder{}}

      iex> update_work_order(work_order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_work_order(%WorkOrder{} = work_order, attrs) do
    work_order
    |> WorkOrder.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a work_order.

  ## Examples

      iex> delete_work_order(work_order)
      {:ok, %WorkOrder{}}

      iex> delete_work_order(work_order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_work_order(%WorkOrder{} = work_order) do
    Repo.delete(work_order)
  end

  def get_uncompleted_and_today_workorder do
    project_ids =
      from(project in Project,
        where: project.status in ["Not Started", "Started"],
        select: project.id
      )
      |> Repo.all()

    WorkOrder
    |> where([wo], wo.project_id in ^project_ids and wo.status in ["Not Started", "Started"])
    |> preload([:project, project: :equipment, project: :users])
    |> preload([:work_order_tasks, work_order_tasks: :task])
    |> Repo.all()
  end

  def get_uncompleted_and_today_workorder_by_id!(id) do
    project_ids =
      from(project in Project,
        where: project.status in ["Not Started", "Started"],
        select: project.id
      )
      |> Repo.all()

    WorkOrder
    |> where([wo], wo.project_id in ^project_ids and wo.status in ["Not Started", "Started"])
    |> preload([:project, project: :equipment, project: :users])
    |> preload([:work_order_tasks, work_order_tasks: :task])
    |> Repo.get!(id)
  end

  def list_workorders_by_date_range(nil, nil, offset, limit, sort, order, search) do

    WorkOrder
    |> join(:left, [w], p in assoc(w, :project))
    |> join(:left, [w, p], e in assoc(p, :equipment))
    |> where([w, p, e], w.project_id == p.id and p.equipment_id == e.id)
    |> where([w, p, e], ilike(w.status, ^"%#{search}%") or ilike(p.name, ^"%#{search}%") or ilike(e.brand_name, ^"%#{search}%") or ilike(p.type, ^"%#{search}%") or ilike(p.schedule_type, ^"%#{search}%") or ilike(e.variant, ^"%#{search}%"))
    |> select([w, p, e], %{id: w.id, project: p.name, type: p.type, status: w.status, equipment: fragment("concat(?, ' - ', ?)", e.brand_name, e.variant), schedule_type: p.schedule_type, work_order_date: w.work_order_date, start_time: w.start_time})
    |> workorder_list_order_by_field(order, sort)
    |> Repo.paginate(page: offset, page_size: limit)
  end

  def list_workorders_by_date_range(start_date \\ Date.utc_today(), end_date \\ Date.utc_today(), offset \\ 0, limit \\ 10, sort \\ "", order \\ "asc", search \\ "") do
    WorkOrder
    |> join(:left, [w], p in assoc(w, :project))
    |> join(:left, [w, p], e in assoc(p, :equipment))
    |> where([w, p, e], w.project_id == p.id and p.equipment_id == e.id)
    |> where([w], w.work_order_date >= ^start_date and w.work_order_date <= ^end_date )
    |> where([w, p, e], ilike(w.status, ^"%#{search}%") or ilike(p.name, ^"%#{search}%") or ilike(e.brand_name, ^"%#{search}%") or ilike(p.type, ^"%#{search}%") or ilike(p.schedule_type, ^"%#{search}%"))
    |> select([w, p, e], %{id: w.id, project: p.name, type: p.type, status: w.status, equipment: e.brand_name, schedule_type: p.schedule_type, work_order_date: w.work_order_date, start_time: w.start_time})
    |> workorder_list_order_by_field(order, sort)
    |> Repo.paginate(page: offset, page_size: limit)
  end

  defp workorder_list_order_by_field(query, order, sort) do
    case {order, sort} do
      {"asc", "project"} -> query |> order_by([w, p, e], asc: p.name)
      {"desc", "project"} -> query |> order_by([w, p, e], desc: p.name)
      {"asc", "equipment"} -> query |> order_by([w, p, e], asc: e.brand_name)
      {"desc", "equipment"} -> query |> order_by([w, p, e], desc: e.brand_name)
      {"asc", "type"} -> query |> order_by([w, p, e], asc: p.type)
      {"desc", "type"} -> query |> order_by([w, p, e], desc: p.type)
      {"asc", "schedule_type"} -> query |> order_by([w, p, e], asc: p.schedule_type)
      {"desc", "schedule_type"} -> query |> order_by([w, p, e], desc: p.schedule_type)
      {_, _} -> query |> order_by({^String.to_atom(order), ^String.to_atom(sort)})
    end
  end

end
