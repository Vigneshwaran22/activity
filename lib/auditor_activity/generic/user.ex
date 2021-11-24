defmodule AuditorActivity.Generic.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditorActivity.Generic.{Project, Task, Skill, Team}

  schema "users" do
    field :active_status, :boolean, default: true
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    many_to_many(:projects, Project, join_through: "user_projects")
    many_to_many(:tasks, Task, join_through: "user_tasks")
    many_to_many(:teams, Team, join_through: "team_users")
    many_to_many(:skills, Skill, join_through: "user_skills")

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :active_status])
    |> validate_required([:first_name, :last_name, :email, :active_status])
  end
end
