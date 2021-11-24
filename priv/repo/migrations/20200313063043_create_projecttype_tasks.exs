defmodule AuditorActivity.Repo.Migrations.CreateProjecttypeTasks do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:projecttype_tasks, primary_key: false) do
      add(:project_type_id, references(:project_types, on_delete: :delete_all), primary_key: true)
      add(:task_id, references(:tasks, on_delete: :delete_all), primary_key: true)
    end
    create_if_not_exists(index(:projecttype_tasks, [:project_type_id]))
    create_if_not_exists(index(:projecttype_tasks, [:task_id]))

    create_if_not_exists(
      unique_index(:projecttype_tasks, [:project_type_id, :task_id], name: :project_type_id_task_id_unique_index)
    )
  end
end
