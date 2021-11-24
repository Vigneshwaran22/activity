defmodule AuditorActivity.Generic.UserTask do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditorActivity.Generic.{User, Task}

  @already_exists "ALREADY_EXISTS"

  @primary_key false
  schema "user_tasks" do
    belongs_to(:user, User, primary_key: true)
    belongs_to(:task, Task, primary_key: true)

    timestamps()
  end

  @doc false
  def changeset(user_task, attrs) do
    user_task
    |> cast(attrs, [:task_id, :user_id])
    |> validate_required([:task_id, :user_id])
    |> assoc_constraint(:task)
    |> assoc_constraint(:user)
    |> unique_constraint(
      :task_id,
      name: :task_id_user_id_unique_index,
      message: @already_exists
    )
  end
end
