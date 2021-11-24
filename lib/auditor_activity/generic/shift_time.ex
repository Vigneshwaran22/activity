defmodule AuditorActivity.Generic.ShiftTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shift_times" do
    field :name, :string
    field :end_time, :time
    field :start_time, :time

    timestamps()
  end

  @doc false
  def changeset(shift_time, attrs) do
    shift_time
    |> cast(attrs, [:name, :start_time, :end_time])
    |> validate_required([:name, :start_time, :end_time])
  end
end
