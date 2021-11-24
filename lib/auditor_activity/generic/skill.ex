defmodule AuditorActivity.Generic.Skill do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditorActivity.Generic.{User, Team}

  schema "skills" do
    field :name, :string
    many_to_many(:users, User, join_through: "user_skills")
    many_to_many(:teams, Team, join_through: "team_skills")

    timestamps()
  end

  @doc false
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
