defmodule AuditorActivityWeb.TeamTemplateView do
  use AuditorActivityWeb, :view
  alias AuditorActivityWeb.TeamTemplateView

  def render("index.json", %{team_templates: team_templates}) do
    %{
      team_templates: render_many(team_templates, TeamTemplateView, "team_templates.json"),
      page_number: team_templates.page_number,
      page_size: team_templates.page_size,
      total_entries: team_templates.total_entries,
      total_pages: team_templates.total_pages
    }
  end

  def render("show.json", %{team_template: team_template}) do
    %{data: render_one(team_template, TeamTemplateView, "team_template.json")}
  end

  def render("team_templates.json", %{team_template: team_template}) do
    %{
      id: team_template.id,
      name: team_template.name,
      description: team_template.description
    }
  end

  def render("team_template.json", %{team_template: team_template}) do
    %{
      id: team_template.id,
      name: team_template.name,
      description: team_template.description,
      resources:
        case is_list(team_template.resources) do
          true ->
            Enum.map(team_template.resources, fn resource ->
              %{id: resource.id, skill: resource.skill, users: resource.users}
            end)

          false ->
            []
        end
    }
  end
end
