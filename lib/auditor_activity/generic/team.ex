defmodule AuditorActivity.Generic.Team do
  use Ecto.Schema
  import Ecto.Changeset

  alias AuditorActivity.Generic.{User, Skill}

  schema "teams" do
    field :name, :string
    field :user_count, :integer
    many_to_many(:users, User, join_through: "team_users")
    many_to_many(:skills, Skill, join_through: "team_skills")

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :user_count])
    |> validate_required([:name, :user_count])
  end
end
