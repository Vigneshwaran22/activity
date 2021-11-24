defmodule AuditorActivity.Repo.Migrations.CreateEquipments do
  use Ecto.Migration

  def change do
    create table(:equipments) do
      add :variant, :string
      add :brand_name, :string
      add :serial_no, :string
      add :equipment_category_id, references(:equipment_categories, on_delete: :nothing)

      timestamps()
    end
    create index(:equipments, [:equipment_category_id])

  end
end
