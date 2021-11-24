defmodule AuditorActivity.Generic.WorkOrderChecklist do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditorActivity.Generic.{WorkOrderTask, Checklist, WorkOrderCheckpoint}

  schema "work_order_checklists" do
    field :status, :string, default: "Not Started"
    belongs_to :work_order_task, WorkOrderTask
    belongs_to :checklist, Checklist
    has_many(:work_order_checkpoints, WorkOrderCheckpoint, on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(work_order_checklist, attrs) do
    work_order_checklist
    |> cast(attrs, [:status, :work_order_task_id, :checklist_id])
    |> validate_inclusion(:status, ["Not Started", "Started", "Completed", "Suspend"])
    |> assoc_constraint(:work_order_task)
    |> assoc_constraint(:checklist)
    |> cast_assoc(:work_order_checkpoints)
  end
end
