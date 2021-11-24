defmodule AuditorActivity.Generic.Checklist do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditorActivity.Generic.{ Checkpoint, Task }

  schema "checklists" do
    field :description, :string
    field :name, :string
    field :active_status, :boolean, default: true
    has_many(:checkpoints, Checkpoint, on_replace: :delete)
    belongs_to(:task, Task)
    # many_to_many(:tasks, Task, join_through: "checklist_tasks")
    timestamps()
  end

  @doc false
  def changeset(checklist, attrs) do
    checklist
    |> cast(attrs, [:name, :description, :task_id, :active_status])
    |> validate_required([:name])
    |> cast_assoc(:checkpoints)
    |> assoc_constraint(:task)
  end
end
