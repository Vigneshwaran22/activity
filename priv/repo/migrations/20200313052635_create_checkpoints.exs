defmodule AuditorActivity.Repo.Migrations.CreateCheckpoints do
  use Ecto.Migration

  def change do
    create table(:checkpoints) do
      add :name, :string
      add :type, :string
      add :options, {:array, :string}
      add :sub_type, :string
      add :status, :boolean
      add :checklist_id, references(:checklists, on_delete: :delete_all)

      timestamps()
    end

    create index(:checkpoints, [:checklist_id])
  end
end
