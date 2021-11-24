defmodule AuditorActivity.Generic.ProjectType do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditorActivity.Generic.{Task, EquipmentCategory}

  schema "project_types" do
    field :description, :string
    field :name, :string
    field :planning, :string
    belongs_to(:equipment_category, EquipmentCategory)
    many_to_many(:tasks, Task, join_through: "projecttype_tasks")
    timestamps()
  end

  @doc false
  def changeset(project_type, attrs) do
    project_type
    |> cast(attrs, [:name, :description, :planning, :equipment_category_id])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> assoc_constraint(:equipment_category)
  end
end
