defmodule AuditorActivity.Generic.UserSkill do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditorActivity.Generic.{User, Skill}

  @already_exists "ALREADY_EXISTS"

  @primary_key false
  schema "user_skills" do
    belongs_to(:user, User, primary_key: true)
    belongs_to(:skill, Skill, primary_key: true)

    timestamps()
  end

  @doc false
  def changeset(user_skill, attrs) do
    user_skill
    |> cast(attrs, [:skill_id, :user_id])
    |> validate_required([:skill_id, :user_id])
    |> assoc_constraint(:skill)
    |> assoc_constraint(:user)
    |> unique_constraint(
      :skill_id,
      name: :skill_id_user_id_unique_index,
      message: @already_exists
    )
  end
end
