defmodule AuditorActivity.Generic do
  @moduledoc """
  The Generic context.
  """

  import Ecto.Query, warn: false
  alias AuditorActivity.Repo
  alias Ecto.Multi

  alias AuditorActivity.Generic.{
    WorkOrderTask,
    Skill,
    UserSkill,
    WorkOrderCheckpoint,
    WorkOrderChecklist
  }

  @doc """
  Returns the list of work_order_tasks.

  ## Examples

      iex> list_work_order_tasks()
      [%WorkOrderTask{}, ...]

  """
  def list_work_order_tasks do
    Repo.all(WorkOrderTask)
  end

  @doc """
  Gets a single work_order_task.

  Raises `Ecto.NoResultsError` if the Work order task does not exist.

  ## Examples

      iex> get_work_order_task!(123)
      %WorkOrderTask{}

      iex> get_work_order_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_work_order_task!(id) do
    WorkOrderTask
    |> preload(:task)
    |> preload([:work_order_checklists, work_order_checklists: :checklist])
    |> Repo.get!(id)
  end

  @doc """
  Creates a work_order_task.

  ## Examples

      iex> create_work_order_task(%{field: value})
      {:ok, %WorkOrderTask{}}

      iex> create_work_order_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_work_order_task(attrs \\ %{}) do
    %WorkOrderTask{}
    |> WorkOrderTask.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a work_order_task.

  ## Examples

      iex> update_work_order_task(work_order_task, %{field: new_value})
      {:ok, %WorkOrderTask{}}

      iex> update_work_order_task(work_order_task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_work_order_task(%WorkOrderTask{} = work_order_task, attrs) do
    work_order_task
    |> WorkOrderTask.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a work_order_task.

  ## Examples

      iex> delete_work_order_task(work_order_task)
      {:ok, %WorkOrderTask{}}

      iex> delete_work_order_task(work_order_task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_work_order_task(%WorkOrderTask{} = work_order_task) do
    Repo.delete(work_order_task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking work_order_task changes.

  ## Examples

      iex> change_work_order_task(work_order_task)
      %Ecto.Changeset{source: %WorkOrderTask{}}

  """
  def change_work_order_task(%WorkOrderTask{} = work_order_task) do
    WorkOrderTask.changeset(work_order_task, %{})
  end

  @doc """
  Returns the list of work_order_checklist.

  ## Examples

      iex> list_work_order_checklist()
      [%WorkOrderChecklist{}, ...]

  """
  def list_work_order_checklist do
    Repo.all(WorkOrderChecklist)
  end

  @doc """
  Gets a single work_order_checklist.

  Raises `Ecto.NoResultsError` if the Work order checklist does not exist.

  ## Examples

      iex> get_work_order_checklist!(123)
      %WorkOrderChecklist{}

      iex> get_work_order_checklist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_work_order_checklist!(id) do
    Repo.get!(WorkOrderChecklist, id)

    WorkOrderChecklist
    # |> preload(:task)
    |> preload([:work_order_checkpoints, work_order_checkpoints: :checkpoint])
    |> Repo.get!(id)
  end

  @doc """
  Creates a work_order_checklist.

  ## Examples

      iex> create_work_order_checklist(%{field: value})
      {:ok, %WorkOrderChecklist{}}

      iex> create_work_order_checklist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_work_order_checklist(attrs \\ %{}) do
    %WorkOrderChecklist{}
    |> WorkOrderChecklist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a work_order_checklist.

  ## Examples

      iex> update_work_order_checklist(work_order_checklist, %{field: new_value})
      {:ok, %WorkOrderChecklist{}}

      iex> update_work_order_checklist(work_order_checklist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_work_order_checklist(%WorkOrderChecklist{} = work_order_checklist, attrs) do
    work_order_checklist
    |> WorkOrderChecklist.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a work_order_checklist.

  ## Examples

      iex> delete_work_order_checklist(work_order_checklist)
      {:ok, %WorkOrderChecklist{}}

      iex> delete_work_order_checklist(work_order_checklist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_work_order_checklist(%WorkOrderChecklist{} = work_order_checklist) do
    Repo.delete(work_order_checklist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking work_order_checklist changes.

  ## Examples

      iex> change_work_order_checklist(work_order_checklist)
      %Ecto.Changeset{source: %WorkOrderChecklist{}}

  """
  def change_work_order_checklist(%WorkOrderChecklist{} = work_order_checklist) do
    WorkOrderChecklist.changeset(work_order_checklist, %{})
  end

  @doc """
  Returns the list of work_order_checkpoint.

  ## Examples

      iex> list_work_order_checkpoint()
      [%WorkOrderCheckpoint{}, ...]

  """
  def list_work_order_checkpoint do
    Repo.all(WorkOrderCheckpoint)
  end

  @doc """
  Gets a single work_order_checkpoint.

  Raises `Ecto.NoResultsError` if the Work order checkpoint does not exist.

  ## Examples

      iex> get_work_order_checkpoint!(123)
      %WorkOrderCheckpoint{}

      iex> get_work_order_checkpoint!(456)
      ** (Ecto.NoResultsError)

  """
  def get_work_order_checkpoint!(id), do: Repo.get!(WorkOrderCheckpoint, id)

  @doc """
  Creates a work_order_checkpoint.

  ## Examples

      iex> create_work_order_checkpoint(%{field: value})
      {:ok, %WorkOrderCheckpoint{}}

      iex> create_work_order_checkpoint(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_work_order_checkpoint(attrs \\ %{}) do
    %WorkOrderCheckpoint{}
    |> WorkOrderCheckpoint.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a work_order_checkpoint.

  ## Examples

      iex> update_work_order_checkpoint(work_order_checkpoint, %{field: new_value})
      {:ok, %WorkOrderCheckpoint{}}

      iex> update_work_order_checkpoint(work_order_checkpoint, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_work_order_checkpoint(%WorkOrderCheckpoint{} = work_order_checkpoint, attrs) do
    work_order_checkpoint
    |> WorkOrderCheckpoint.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a work_order_checkpoint.

  ## Examples

      iex> delete_work_order_checkpoint(work_order_checkpoint)
      {:ok, %WorkOrderCheckpoint{}}

      iex> delete_work_order_checkpoint(work_order_checkpoint)
      {:error, %Ecto.Changeset{}}

  """
  def delete_work_order_checkpoint(%WorkOrderCheckpoint{} = work_order_checkpoint) do
    Repo.delete(work_order_checkpoint)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking work_order_checkpoint changes.

  ## Examples

      iex> change_work_order_checkpoint(work_order_checkpoint)
      %Ecto.Changeset{source: %WorkOrderCheckpoint{}}

  """
  def change_work_order_checkpoint(%WorkOrderCheckpoint{} = work_order_checkpoint) do
    WorkOrderCheckpoint.changeset(work_order_checkpoint, %{})
  end

  @doc """
  Returns the list of skills.

  ## Examples

      iex> list_skills()
      [%Skill{}, ...]

  """
  def list_skills(offset \\ 0, limit \\ 10, sort \\ "name", order \\ "asc", search \\ "") do
    # Repo.all(Skill)
    limit =
      case limit do
        "all" -> Skill |> select(count("*")) |> Repo.one()
        _ -> limit
      end

    Skill
    |> order_by({^String.to_atom(order), ^String.to_atom(sort)})
    |> where([u], ilike(u.name, ^"%#{search}%"))
    |> Repo.paginate(page: offset, page_size: limit)
  end

  @doc """
  Gets a single skill.

  Raises `Ecto.NoResultsError` if the Skill does not exist.

  ## Examples

      iex> get_skill!(123)
      %Skill{}

      iex> get_skill!(456)
      ** (Ecto.NoResultsError)

  """
  def get_skill!(id), do: Repo.get!(Skill, id)

  @doc """
  Creates a skill.

  ## Examples

      iex> create_skill(%{field: value})
      {:ok, %Skill{}}

      iex> create_skill(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_skill(attrs \\ %{}) do
    %Skill{}
    |> Skill.changeset(attrs)
    |> Repo.insert()
    |> skill_users(attrs)
  end

  @doc """
  Updates a skill.

  ## Examples

      iex> update_skill(skill, %{field: new_value})
      {:ok, %Skill{}}

      iex> update_skill(skill, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_skill(%Skill{} = skill, attrs) do
    skill
    |> Skill.changeset(attrs)
    |> Repo.update()
    |> skill_users(attrs)
  end

  @doc """
  Deletes a skill.

  ## Examples

      iex> delete_skill(skill)
      {:ok, %Skill{}}

      iex> delete_skill(skill)
      {:error, %Ecto.Changeset{}}

  """
  def delete_skill(%Skill{} = skill) do
    Repo.delete(skill)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking skill changes.

  ## Examples

      iex> change_skill(skill)
      %Ecto.Changeset{source: %Skill{}}

  """
  def change_skill(%Skill{} = skill) do
    Skill.changeset(skill, %{})
  end

  def skill_users(response, attrs) do
    case {response, Map.has_key?(attrs, "users")} do
      {{:ok, skill_instance}, true} ->
        case make_relation_with_skill_and_users(
               skill_instance.id,
               Map.get(attrs, "users")
             ) do
          {:ok, _} -> {:ok, Repo.preload(skill_instance, [:users])}
          error_response -> error_response
        end

      _ ->
        response
    end
  end

  def make_relation_with_skill_and_users(skill_id, user_ids) do
    skill_users =
      user_ids
      |> Enum.uniq()
      |> Enum.map(fn user_id ->
        %{
          user_id: user_id,
          skill_id: skill_id
        }
      end)

    multi =
      Multi.new()
      |> Multi.delete_all(
        :delete_all,
        UserSkill |> where([ut], ut.skill_id == ^skill_id)
      )
      |> Multi.insert_all(:insert_all, UserSkill, skill_users)

    case Repo.transaction(multi) do
      {:ok, _multi_result} ->
        {:ok, :updated}

      {:error, changeset} ->
        {:error, changeset}

      {:error, _, changeset, _} ->
        {:error, changeset}
    end
  end

  alias AuditorActivity.Generic.ShiftTime

  @doc """
  Returns the list of shift_times.

  ## Examples

      iex> list_shift_times()
      [%ShiftTime{}, ...]

  """
  def list_shift_times(offset \\ 0, limit \\ 10, sort \\ "name", order \\ "asc", search \\ "") do
    # Repo.all(ShiftTime)
    limit =
      case limit do
        "all" -> ShiftTime |> select(count("*")) |> Repo.one()
        _ -> limit
      end

    ShiftTime
    |> order_by({^String.to_atom(order), ^String.to_atom(sort)})
    |> where([u], ilike(u.name, ^"%#{search}%"))
    |> Repo.paginate(page: offset, page_size: limit)
  end

  @doc """
  Gets a single shift_time.

  Raises `Ecto.NoResultsError` if the Shift time does not exist.

  ## Examples

      iex> get_shift_time!(123)
      %ShiftTime{}

      iex> get_shift_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_shift_time!(id), do: Repo.get!(ShiftTime, id)

  @doc """
  Creates a shift_time.

  ## Examples

      iex> create_shift_time(%{field: value})
      {:ok, %ShiftTime{}}

      iex> create_shift_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_shift_time(attrs \\ %{}) do
    %ShiftTime{}
    |> ShiftTime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a shift_time.

  ## Examples

      iex> update_shift_time(shift_time, %{field: new_value})
      {:ok, %ShiftTime{}}

      iex> update_shift_time(shift_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_shift_time(%ShiftTime{} = shift_time, attrs) do
    shift_time
    |> ShiftTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a shift_time.

  ## Examples

      iex> delete_shift_time(shift_time)
      {:ok, %ShiftTime{}}

      iex> delete_shift_time(shift_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_shift_time(%ShiftTime{} = shift_time) do
    Repo.delete(shift_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking shift_time changes.

  ## Examples

      iex> change_shift_time(shift_time)
      %Ecto.Changeset{source: %ShiftTime{}}

  """
  def change_shift_time(%ShiftTime{} = shift_time) do
    ShiftTime.changeset(shift_time, %{})
  end

  # alias AuditorActivity.Generic.Skill

  # @doc """
  # Returns the list of skills.

  # ## Examples

  #     iex> list_skills()
  #     [%Skill{}, ...]

  # """
  # def list_skills do
  #   Repo.all(Skill)
  # end

  # @doc """
  # Gets a single skill.

  # Raises `Ecto.NoResultsError` if the Skill does not exist.

  # ## Examples

  #     iex> get_skill!(123)
  #     %Skill{}

  #     iex> get_skill!(456)
  #     ** (Ecto.NoResultsError)

  # """
  # def get_skill!(id), do: Repo.get!(Skill, id)

  # @doc """
  # Creates a skill.

  # ## Examples

  #     iex> create_skill(%{field: value})
  #     {:ok, %Skill{}}

  #     iex> create_skill(%{field: bad_value})
  #     {:error, %Ecto.Changeset{}}

  # """
  # def create_skill(attrs \\ %{}) do
  #   %Skill{}
  #   |> Skill.changeset(attrs)
  #   |> Repo.insert()
  # end

  # @doc """
  # Updates a skill.

  # ## Examples

  #     iex> update_skill(skill, %{field: new_value})
  #     {:ok, %Skill{}}

  #     iex> update_skill(skill, %{field: bad_value})
  #     {:error, %Ecto.Changeset{}}

  # """
  # def update_skill(%Skill{} = skill, attrs) do
  #   skill
  #   |> Skill.changeset(attrs)
  #   |> Repo.update()
  # end

  # @doc """
  # Deletes a skill.

  # ## Examples

  #     iex> delete_skill(skill)
  #     {:ok, %Skill{}}

  #     iex> delete_skill(skill)
  #     {:error, %Ecto.Changeset{}}

  # """
  # def delete_skill(%Skill{} = skill) do
  #   Repo.delete(skill)
  # end

  # @doc """
  # Returns an `%Ecto.Changeset{}` for tracking skill changes.

  # ## Examples

  #     iex> change_skill(skill)
  #     %Ecto.Changeset{source: %Skill{}}

  # """
  # def change_skill(%Skill{} = skill) do
  #   Skill.changeset(skill, %{})
  # end
end
