defmodule AuditorActivity.Repo.Migrations.CreateTeamUsers do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:team_users, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all), primary_key: true
      add :team_id, references(:teams, on_delete: :delete_all), primary_key: true

      timestamps()
    end

    create_if_not_exists index(:team_users, [:user_id])
    create_if_not_exists index(:team_users, [:team_id])

    create_if_not_exists(
      unique_index(:team_users, [:user_id, :team_id], name: :team_id_user_id_unique_index)
    )
  end
end
