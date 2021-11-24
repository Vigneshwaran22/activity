defmodule AuditorActivity.Repo.Migrations.CreateWorkOrderChecklist do
  use Ecto.Migration

  def change do
    create table(:work_order_checklists) do
      add :status, :string
      add :work_order_task_id, references(:work_order_tasks, on_delete: :nothing)
      add :checklist_id, references(:checklists, on_delete: :nothing)

      timestamps()
    end

    create index(:work_order_checklists, [:work_order_task_id])
    create index(:work_order_checklists, [:checklist_id])
  end
end
