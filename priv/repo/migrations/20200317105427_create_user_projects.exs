defmodule AuditorActivity.Repo.Migrations.CreateUserProject do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:user_projects, primary_key: false) do
      add(:project_id, references(:projects, on_delete: :delete_all), primary_key: true)
      add(:user_id, references(:users, on_delete: :delete_all), primary_key: true)
    end
    create_if_not_exists(index(:user_projects, [:project_id]))
    create_if_not_exists(index(:user_projects, [:user_id]))

    create_if_not_exists(
      unique_index(:user_projects, [:project_id, :user_id], name: :project_id_user_id_unique_index)
    )
  end
end
