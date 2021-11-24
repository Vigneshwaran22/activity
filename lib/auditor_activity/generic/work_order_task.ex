defmodule AuditorActivity.Generic.WorkOrderTask do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditorActivity.Generic.{WorkOrder, Task, WorkOrderChecklist}

  schema "work_order_tasks" do
    field :completed_on, :utc_datetime
    field :end_date, :date
    field :start_date, :date
    field :started_on, :utc_datetime
    field :status, :string, default: "Not Started"
    field :time_to_finish, :utc_datetime

    belongs_to :work_order, WorkOrder
    belongs_to :task, Task
    has_many :work_order_checklists, WorkOrderChecklist, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(work_order_task, attrs) do
    work_order_task
    |> cast(attrs, [
      :status,
      :start_date,
      :end_date,
      :started_on,
      :completed_on,
      :time_to_finish,
      :work_order_id,
      :task_id
    ])
    |> validate_inclusion(:status, ["Not Started", "Started", "Completed", "Suspend"])
    |> assoc_constraint(:work_order)
    |> assoc_constraint(:task)
    |> cast_assoc(:work_order_checklists)
  end
end
