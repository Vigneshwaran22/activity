defmodule AuditorActivity.Repo.Migrations.CreateProjectTypes do
  use Ecto.Migration

  def change do
    create table(:project_types) do
      add :name, :string
      add :description, :string
      add :planning, :string
      add :equipment_category_id, references(:equipment_categories, on_delete: :nothing)

      timestamps()
    end
    create index(:project_types, [:equipment_category_id])

  end
end
