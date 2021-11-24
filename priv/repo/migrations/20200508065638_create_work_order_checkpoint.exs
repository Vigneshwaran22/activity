defmodule AuditorActivity.Repo.Migrations.CreateWorkOrderCheckpoint do
  use Ecto.Migration

  def change do
    create table(:work_order_checkpoints) do
      add :status, :string
      add :value, :string
      add :check_value, :boolean
      add :selected_value, :string
      add :work_order_checklist_id, references(:work_order_checklists, on_delete: :nothing)
      add :checkpoint_id, references(:checkpoints, on_delete: :nothing)

      timestamps()
    end

    create index(:work_order_checkpoints, [:work_order_checklist_id])
    create index(:work_order_checkpoints, [:checkpoint_id])
  end
end
