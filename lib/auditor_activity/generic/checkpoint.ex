defmodule AuditorActivity.Generic.Checkpoint do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditorActivity.Generic.Checklist

  schema "checkpoints" do
    field :name, :string
    field :type, :string
    field :options, {:array, :string}, default: []
    field :sub_type, :string
    field :status, :boolean, default: true
    belongs_to(:checklist, Checklist)
    timestamps()
  end

  @doc false
  def changeset(checkpoint, attrs) do
    checkpoint
    |> cast(attrs, [:name, :type, :status, :options, :sub_type, :checklist_id])
    |> validate_required([:name, :type])
    |> assoc_constraint(:checklist)
  end
end
