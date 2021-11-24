defmodule AuditorActivity.Repo.Migrations.CreateUserTasks do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:user_tasks, primary_key: false) do
      add(:task_id, references(:tasks, on_delete: :delete_all), primary_key: true)
      add(:user_id, references(:users, on_delete: :delete_all), primary_key: true)
    end
    create_if_not_exists(index(:user_tasks, [:task_id]))
    create_if_not_exists(index(:user_tasks, [:user_id]))

    create_if_not_exists(
      unique_index(:user_tasks, [:task_id, :user_id], name: :task_id_user_id_unique_index)
    )
  end
end
