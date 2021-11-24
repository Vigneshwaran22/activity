defmodule AuditorActivity.Generic.Equipment do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditorActivity.Generic.{Project, EquipmentCategory}

  schema "equipments" do
    field :variant, :string
    field :brand_name, :string
    field :serial_no, :string
    has_many(:project, Project, on_replace: :delete)
    belongs_to(:equipment_category, EquipmentCategory)

    timestamps()
  end

  @doc false
  def changeset(equipment, attrs) do
    equipment
    |> cast(attrs, [:variant, :brand_name, :serial_no, :equipment_category_id])
    |> validate_required([:variant, :brand_name, :serial_no, :equipment_category_id])
    |> cast_assoc(:project)
    |> assoc_constraint(:equipment_category)
  end
end
