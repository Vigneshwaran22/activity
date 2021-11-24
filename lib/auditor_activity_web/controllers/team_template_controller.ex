defmodule AuditorActivityWeb.TeamTemplateController do
  use AuditorActivityWeb, :controller

  alias AuditorActivity.TeamSettings
  alias AuditorActivity.Generic.TeamTemplate

  action_fallback AuditorActivityWeb.FallbackController

  def index(conn, %{"offset" => offset, "limit" => limit, "sort" => sort, "order" => order, "search" => search}) do
    team_templates = TeamSettings.list_team_templates(offset, limit, sort, order, search)
    render(conn, "index.json", team_templates: team_templates)
  end

  def create(conn, %{"team_template" => team_template_params}) do
    with {:ok, %TeamTemplate{} = team_template} <- TeamSettings.create_team_template(team_template_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.team_template_path(conn, :show, team_template))
      |> render("show.json", team_template: team_template)
    end
  end

  def show(conn, %{"id" => id}) do
    team_template = TeamSettings.get_team_template!(id)
    render(conn, "show.json", team_template: team_template)
  end

  def update(conn, %{"id" => id, "team_template" => team_template_params}) do
    team_template = TeamSettings.get_team_template!(id)

    with {:ok, %TeamTemplate{} = team_template} <- TeamSettings.update_team_template(team_template, team_template_params) do
      render(conn, "show.json", team_template: team_template)
    end
  end

  def delete(conn, %{"id" => id}) do
    team_template = TeamSettings.get_team_template!(id)

    with {:ok, %TeamTemplate{}} <- TeamSettings.delete_team_template(team_template) do
      send_resp(conn, :no_content, "")
    end
  end
end
