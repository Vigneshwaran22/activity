defmodule AuditorActivity.Repo.Migrations.CreateChecklistTasks do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:checklist_tasks, primary_key: false) do
      add(:task_id, references(:tasks, on_delete: :delete_all), primary_key: true)
      add(:checklist_id, references(:checklists, on_delete: :delete_all), primary_key: true)
    end
    create_if_not_exists(index(:checklist_tasks, [:task_id]))
    create_if_not_exists(index(:checklist_tasks, [:checklist_id]))

    create_if_not_exists(
      unique_index(:checklist_tasks, [:task_id, :checklist_id], name: :task_id_checklist_id_unique_index)
    )
  end
end
