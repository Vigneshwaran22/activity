defmodule AuditorActivity.Generic.TeamTemplate do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditorActivity.Generic.Project

  schema "team_templates" do
    field :description, :string
    field :name, :string

    embeds_many :resources, Resource, on_replace: :delete do
      field :skill, :integer
      field :users, :integer
    end

    has_many :projects, Project, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(team_template, attrs) do
    team_template
    |> cast(attrs, [:name, :description])
    |> cast_embed(:resources, with: &resource_changeset/2)
    |> validate_required([:name, :description])
    |> cast_assoc(:projects)
  end

  defp resource_changeset(schema, params) do
    schema
    |> cast(params, [:skill, :users])
  end
end
