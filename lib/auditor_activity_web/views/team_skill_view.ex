defmodule AuditorActivityWeb.TeamSkillView do
  use AuditorActivityWeb, :view
  alias AuditorActivityWeb.TeamSkillView

  def render("index.json", %{team_skills: team_skills}) do
    %{data: render_many(team_skills, TeamSkillView, "team_skill.json")}
  end

  def render("show.json", %{team_skill: team_skill}) do
    %{data: render_one(team_skill, TeamSkillView, "team_skill.json")}
  end

  def render("team_skill.json", %{team_skill: team_skill}) do
    %{id: team_skill.id}
  end
end
