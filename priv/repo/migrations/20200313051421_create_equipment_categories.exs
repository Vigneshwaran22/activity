defmodule AuditorActivity.Repo.Migrations.CreateEquipmentCategories do
  use Ecto.Migration

  def change do
    create table(:equipment_categories) do
      add :name, :string

      timestamps()
    end

  end
end
