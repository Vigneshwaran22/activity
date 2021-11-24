defmodule AuditorActivity.Repo.Migrations.CreateUserSkills do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:user_skills, primary_key: false) do
      add(:skill_id, references(:skills, on_delete: :delete_all), primary_key: true)
      add(:user_id, references(:users, on_delete: :delete_all), primary_key: true)
    end

    create_if_not_exists(index(:user_skills, [:skill_id]))
    create_if_not_exists(index(:user_skills, [:user_id]))

    create_if_not_exists(
      unique_index(:user_skills, [:skill_id, :user_id], name: :skill_id_user_id_unique_index)
    )
  end
end
