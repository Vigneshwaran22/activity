defmodule AuditorActivity.Generic.Project do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditorActivity.Generic.{ProjectType, User, Equipment, WorkOrder, TeamTemplate}

  schema "projects" do
    field(:name, :string)
    field(:schedule_type, :string)
    field(:type, :string)
    field(:start_hour, :time)
    field(:end_hour, :time)
    field(:day_of_week, :integer)
    field(:fortnite, :integer)
    field(:day_of_month, :integer)
    field(:month, :integer)
    field(:month2, :integer)
    field(:description, :string)
    field(:month3, :integer)
    field(:month4, :integer)
    field(:start_date, :date)
    field(:end_date, :date)
    field(:started_on, :utc_datetime)
    field(:completed_on, :utc_datetime)
    field(:restricted, :boolean, default: true)
    field(:status, :string, default: "Not Started")
    field(:next_workorder_date, :utc_datetime)
    belongs_to(:project_type, ProjectType)
    belongs_to(:equipment, Equipment)
    belongs_to(:team_template, TeamTemplate)
    has_many(:work_orders, WorkOrder, on_replace: :delete)
    many_to_many(:users, User, join_through: "user_projects")
    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [
      :name,
      :schedule_type,
      :type,
      :description,
      :month,
      :month2,
      :month3,
      :month4,
      :start_hour,
      :end_hour,
      :day_of_month,
      :day_of_week,
      :fortnite,
      :start_date,
      :end_date,
      :started_on,
      :completed_on,
      :status,
      :next_workorder_date,
      :project_type_id,
      :equipment_id,
      :restricted,
      :team_template_id
    ])
    |> validate_required([:name, :type, :start_date, :start_hour, :equipment_id, :project_type_id ])
    |> project_type_validation()
    |> validate_inclusion(:type, ["Schedule", "Ad hoc"])
    |> validate_inclusion(:schedule_type, [
      "Daily",
      "Weekly",
      "Fortnight",
      "Monthly",
      "Quarterly",
      "Half yearly",
      "Annually"
    ])
    |> validate_inclusion(:status, ["Not Started", "Started", "Completed", "Suspend"])
    |> type_validation()
    |> assoc_constraint(:project_type)
    |> assoc_constraint(:equipment)
    |> assoc_constraint(:team_template)
    |> cast_assoc(:work_orders)
  end

  defp project_type_validation(changeset) do
    case {get_field(changeset, :id), get_change(changeset, :project_type_id)} do
      {nil, _} -> changeset
      {_, nil} -> changeset
      {_, _} -> add_error(changeset, :project_type_id, "Can't change the project type")
    end
  end

  defp type_validation(changeset) do
    case {get_field(changeset, :id), get_change(changeset, :type)} do
      {nil, _} -> changeset
      {_, nil} -> changeset
      {_, _} -> add_error(changeset, :type, "Can't change the type")
    end
  end
end
