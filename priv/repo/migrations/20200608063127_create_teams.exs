defmodule AuditorActivity.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :user_count, :integer

      timestamps()
    end

  end
end
