defmodule AuditorActivity.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :description, :string
      add :time_to_finish, :time
      add :type, :string
      # add :checklists_list, {:array, :integer}, default: []
      # add :status, :string
      # add :start_date, :date
      # add :end_date, :date
      # add :started_on, :utc_datetime
      # add :completed_on, :utc_datetime
      # add :work_order_id, references(:work_orders, on_delete: :nothing)

      timestamps()
    end
    # create index(:tasks, [:work_order_id])

  end
end
