defmodule AuditorActivityWeb.TeamTemplateControllerTest do
  use AuditorActivityWeb.ConnCase

  alias AuditorActivity.Generic
  alias AuditorActivity.Generic.TeamTemplate

  @create_attrs %{
    description: "some description",
    name: "some name"
  }
  @update_attrs %{
    description: "some updated description",
    name: "some updated name"
  }
  @invalid_attrs %{description: nil, name: nil}

  def fixture(:team_template) do
    {:ok, team_template} = Generic.create_team_template(@create_attrs)
    team_template
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all team_templates", %{conn: conn} do
      conn = get(conn, Routes.team_template_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create team_template" do
    test "renders team_template when data is valid", %{conn: conn} do
      conn = post(conn, Routes.team_template_path(conn, :create), team_template: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.team_template_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.team_template_path(conn, :create), team_template: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update team_template" do
    setup [:create_team_template]

    test "renders team_template when data is valid", %{conn: conn, team_template: %TeamTemplate{id: id} = team_template} do
      conn = put(conn, Routes.team_template_path(conn, :update, team_template), team_template: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.team_template_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, team_template: team_template} do
      conn = put(conn, Routes.team_template_path(conn, :update, team_template), team_template: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete team_template" do
    setup [:create_team_template]

    test "deletes chosen team_template", %{conn: conn, team_template: team_template} do
      conn = delete(conn, Routes.team_template_path(conn, :delete, team_template))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.team_template_path(conn, :show, team_template))
      end
    end
  end

  defp create_team_template(_) do
    team_template = fixture(:team_template)
    {:ok, team_template: team_template}
  end
end
