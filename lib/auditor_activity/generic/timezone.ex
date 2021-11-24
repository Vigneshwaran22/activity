defmodule AuditorActivity.Generic.Timezone do
  use Ecto.Schema
  import Ecto.Changeset

  schema "timezones" do
    field :city, :string
    field :city_low, :string
    field :city_stripped, :string
    field :continent, :string
    field :label, :string
    field :offset, :string
    field :state, :string
    field :utc_offset_seconds, :integer

    timestamps()
  end

  @doc false
  def changeset(timezone, attrs) do
    timezone
    |> cast(attrs, [:continent, :label, :state, :city, :city_low, :city_stripped, :offset, :utc_offset_seconds])
    |> validate_required([:city, :offset, :city_low, :city_stripped, :utc_offset_seconds])
  end
end
