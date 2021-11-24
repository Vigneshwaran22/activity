defmodule AuditorActivity.Repo.Migrations.CreateWorkOrders do
  use Ecto.Migration

  def change do
    create table(:work_orders) do
      add :start_time, :time
      add :work_order_date, :date
      add :project_id, references(:projects, on_delete: :nothing)
      add :status, :string

      timestamps()
    end

    create index(:work_orders, [:project_id])
  end
end
