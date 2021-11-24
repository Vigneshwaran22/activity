defmodule AuditorActivity.Generic.UserProject do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditorActivity.Generic.{User, Project}

  @already_exists "ALREADY_EXISTS"

  @primary_key false
  schema "user_projects" do
    belongs_to(:project, Project, primary_key: true)
    belongs_to(:user, User, primary_key: true)

    timestamps()
  end

  @doc false
  def changeset(user_project, attrs) do
    user_project
    |> cast(attrs, [:project_id, :user_id])
    |> validate_required([:project_id, :user_id])
    |> assoc_constraint(:project)
    |> assoc_constraint(:user)
    |> unique_constraint(
      :project_id,
      name: :project_id_user_id_unique_index,
      message: @already_exists
    )
  end
end
