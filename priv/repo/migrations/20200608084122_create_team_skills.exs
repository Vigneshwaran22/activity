defmodule AuditorActivity.Repo.Migrations.CreateTeamSkills do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:team_skills, primary_key: false) do
      add :team_id, references(:teams, on_delete: :delete_all), primary_key: true
      add :skill_id, references(:skills, on_delete: :delete_all), primary_key: true

      timestamps()
    end

    create_if_not_exists(index(:team_skills, [:team_id]))
    create_if_not_exists(index(:team_skills, [:skill_id]))

    create_if_not_exists(
      unique_index(:team_skills, [:skill_id, :team_id], name: :team_id_skill_id_unique_index)
    )
  end
end
