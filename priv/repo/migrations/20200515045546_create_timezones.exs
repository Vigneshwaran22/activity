defmodule AuditorActivity.Repo.Migrations.CreateTimezones do
  use Ecto.Migration

  def change do
    create table(:timezones) do
      add :city, :string
      add :city_low, :string
      add :city_stripped, :string
      add :continent, :string
      add :label, :string
      add :offset, :string
      add :state, :string
      add :utc_offset_seconds, :integer

      timestamps()
    end

  end
end
