defmodule AuditorActivity.Generic.WorkOrderCheckpoint do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditorActivity.Generic.{Checkpoint, WorkOrderChecklist}

  schema "work_order_checkpoints" do
    field :status, :string, default: "Not Started"
    field :value, :string
    field :selected_value, :string
    field :check_value, :boolean, default: false
    belongs_to :work_order_checklist, WorkOrderChecklist
    belongs_to :checkpoint, Checkpoint

    timestamps()
  end

  @doc false
  def changeset(work_order_checkpoint, attrs) do
    work_order_checkpoint
    |> cast(attrs, [:status, :work_order_checklist_id, :selected_value, :checkpoint_id, :value, :check_value])
    |> validate_inclusion(:status, ["Not Started", "Started", "Completed", "Suspend"])
    |> assoc_constraint(:work_order_checklist)
    |> assoc_constraint(:checkpoint)
  end
end
