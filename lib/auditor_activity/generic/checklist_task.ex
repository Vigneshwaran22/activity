defmodule AuditorActivity.Generic.ChecklistTask do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditorActivity.Generic.{Checklist, Task}

  @already_exists "ALREADY_EXISTS"

  @primary_key false
  schema "checklist_tasks" do
    belongs_to(:checklist, Checklist, primary_key: true)
    belongs_to(:task, Task, primary_key: true)

    timestamps()
  end

  @doc false
  def changeset(checklist_task, attrs) do
    checklist_task
    |> cast(attrs, [:task_id, :checklist_id])
    |> validate_required([:task_id, :checklist_id])
    |> assoc_constraint(:task)
    |> assoc_constraint(:checklist)
    |> unique_constraint(
      :task_id,
      name: :task_id_checklist_id_unique_index,
      message: @already_exists
    )
  end
end
