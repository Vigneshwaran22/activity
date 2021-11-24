defmodule AuditorActivity.Generic.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditorActivity.Generic.{Checklist, ProjectType, User}

  schema "tasks" do
    field :description, :string
    field :name, :string
    # field(:status, :string, default: "Not Started")
    # field(:start_date, :date)
    # field :checklists_list, {:array, :integer}, default: []
    # field(:end_date, :date)
    # field(:started_on, :utc_datetime)
    # field(:completed_on, :utc_datetime)
    field :time_to_finish, :time
    field :type, :string
    has_many(:checklists, Checklist, on_replace: :delete)
    # belongs_to(:work_order, WorkOrder)
    # many_to_many(:checklists, Checklist, join_through: "checklist_tasks")
    many_to_many(:project_types, ProjectType, join_through: "projecttype_tasks")
    many_to_many(:users, User, join_through: "user_tasks")
    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [
      :name,
      :description,
      :time_to_finish,
      # :start_date,
      # :end_date,
      # :started_on,
      # :completed_on,
      # :status,
      # :work_order_id,
      # :checklists_list,
      # :checklists
    ])
    |> validate_required([:name])
    # |> validate_inclusion(:status, ["Not Started", "Started", "Completed", "Suspend"])
    |> cast_assoc(:checklists)
    # |> assoc_constraint(:work_order)
  end
end
