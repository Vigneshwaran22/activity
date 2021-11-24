defmodule AuditorActivity.Generic.TeamUser do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditorActivity.Generic.{Team, User}
  @already_exists "ALREADY_EXISTS"

  @primary_key false
  schema "team_users" do
    belongs_to :user_id, User, primary_key: true
    belongs_to :team_id, Team, primary_key: true
    timestamps()
  end

  @doc false
  def changeset(team_user, attrs) do
    team_user
    |> cast(attrs, [:user_id, :team_id])
    |> validate_required([:user_id, :team_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:team)
    |> unique_constraint(:team_id,
      name: :team_id_user_id_unique_index,
      message: @already_exists
    )
  end
end
