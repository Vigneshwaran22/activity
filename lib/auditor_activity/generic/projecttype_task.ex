defmodule AuditorActivity.Generic.ProjecttypeTask do
  use Ecto.Schema
  import Ecto.Changeset

  alias AuditorActivity.Generic.{ ProjectType, Task}

  @already_exists "ALREADY_EXISTS"

  @primary_key false
  schema "projecttype_tasks" do
    belongs_to(:project_type, ProjectType, primary_key: true)
    belongs_to(:task, Task, primary_key: true)

    timestamps()
  end

  @doc false
  def changeset(projecttype_task, attrs) do
    projecttype_task
    |> cast(attrs, [:project_type_id, :task_id])
    |> validate_required([:project_type_id, :task_id])
    |> assoc_constraint(:project_type)
    |> assoc_constraint(:task)
    |> unique_constraint(
      :project_type_id,
      name: :project_type_id_task_id_unique_index,
      message: @already_exists
    )
  end
end
