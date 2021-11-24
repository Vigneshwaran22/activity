defmodule AuditorActivityWeb.TeamUserView do
  use AuditorActivityWeb, :view
  alias AuditorActivityWeb.TeamUserView

  def render("index.json", %{team_users: team_users}) do
    %{data: render_many(team_users, TeamUserView, "team_user.json")}
  end

  def render("show.json", %{team_user: team_user}) do
    %{data: render_one(team_user, TeamUserView, "team_user.json")}
  end

  def render("team_user.json", %{team_user: team_user}) do
    %{id: team_user.id}
  end
end
