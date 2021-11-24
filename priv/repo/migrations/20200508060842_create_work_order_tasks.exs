defmodule AuditorActivity.Repo.Migrations.CreateWorkOrderTasks do
  use Ecto.Migration

  def change do
    create table(:work_order_tasks) do
      add :status, :string
      add :start_date, :date
      add :end_date, :date
      add :started_on, :utc_datetime
      add :completed_on, :utc_datetime
      add :time_to_finish, :utc_datetime
      add :work_order_id, references(:work_orders, on_delete: :nothing)
      add :task_id, references(:tasks, on_delete: :nothing)

      timestamps()
    end

    create index(:work_order_tasks, [:work_order_id])
    create index(:work_order_tasks, [:task_id])
  end
end
