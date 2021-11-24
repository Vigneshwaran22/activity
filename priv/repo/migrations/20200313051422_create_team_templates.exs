defmodule AuditorActivity.Repo.Migrations.CreateTeamTemplates do
  use Ecto.Migration

  def change do
    create table(:team_templates) do
      add :name, :string
      add :description, :string
      add :resources, {:array, :map}, default: []
      timestamps()
    end
  end
end
