defmodule AuditorActivity.Generic.EquipmentCategory do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditorActivity.Generic.Equipment
  schema "equipment_categories" do
    field :name, :string
    has_many(:equipments, Equipment, on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(equipment_category, attrs) do
    equipment_category
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> cast_assoc(:equipments)

  end
end
