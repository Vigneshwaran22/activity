defmodule AuditorActivity.Generic.TeamSkill do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditorActivity.Generic.{Team, Skill}
  @already_exists "ALREADY_EXISTS"

  @primary_key false
  schema "team_skills" do
    belongs_to :team_id, Team, primary_key: true
    belongs_to :skill_id, Skill, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(team_skill, attrs) do
    team_skill
    |> cast(attrs, [])
    |> validate_required([])
    |> assoc_constraint(:skill)
    |> assoc_constraint(:team)
    |> unique_constraint(
      :skill_id,
      name: :skill_id_team_id_unique_index,
      message: @already_exists
    )
  end
end
