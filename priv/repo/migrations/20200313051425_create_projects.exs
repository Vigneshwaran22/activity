defmodule AuditorActivity.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string
      add :schedule_type, :string
      add :type, :string
      add :start_hour, :time
      add :end_hour, :time
      add :day_of_week, :integer
      add :fortnite, :integer
      add :day_of_month, :integer
      add :month, :integer
      add :month2, :integer
      add :month3, :integer
      add :month4, :integer
      add :restricted, :boolean
      add :description, :string
      add :start_date, :date
      add :end_date, :date
      add :started_on, :utc_datetime
      add :completed_on, :utc_datetime
      add :next_workorder_date, :utc_datetime
      add :status, :string
      add :equipment_id, references(:equipments, on_delete: :nothing)
      add :team_template_id, references(:team_templates, on_delete: :nothing)
      add :project_type_id, references(:project_types, on_delete: :nothing)

      timestamps()
    end

    create index(:projects, [:project_type_id])
    create index(:projects, [:equipment_id])
    create index(:projects, [:team_template_id])
  end
end
