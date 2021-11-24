defmodule AuditorActivity.Repo.Migrations.CreateShiftTimes do
  use Ecto.Migration

  def change do
    create table(:shift_times) do
      add :name, :string
      add :start_time, :time
      add :end_time, :time

      timestamps()
    end

  end
end
