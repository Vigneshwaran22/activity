defmodule AuditorActivity.Generic.WorkOrder do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditorActivity.Generic.{Project, WorkOrderTask}

  schema "work_orders" do
    field :work_order_date, :date, default: Date.utc_today()
    field :start_time, :time
    field(:status, :string, default: "Not Started")
    belongs_to(:project, Project)
    has_many(:work_order_tasks, WorkOrderTask, on_replace: :delete)
    timestamps()
  end

  @doc false
  def changeset(work_order, attrs) do
    work_order
    |> cast(attrs, [:project_id, :start_time])
    |> validate_required([:start_time])
    |> validate_inclusion(:status, ["Not Started", "Started", "Completed"])
    |> assoc_constraint(:project)
    |> cast_assoc(:work_order_tasks)
  end
end
