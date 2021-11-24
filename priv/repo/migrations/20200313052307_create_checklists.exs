defmodule AuditorActivity.Repo.Migrations.CreateChecklists do
  use Ecto.Migration

  def change do
    create table(:checklists) do
      add :name, :string
      add :description, :string
      add :task_id, references(:tasks, on_delete: :delete_all)
      add :active_status, :boolean, default: true, null: false
      timestamps()
    end
      create index(:checklists, [:task_id])
  end
end
