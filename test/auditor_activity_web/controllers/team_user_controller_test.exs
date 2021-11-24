defmodule AuditorActivityWeb.TeamUserControllerTest do
  use AuditorActivityWeb.ConnCase

  alias AuditorActivity.Generic
  alias AuditorActivity.Generic.TeamUser

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:team_user) do
    {:ok, team_user} = Generic.create_team_user(@create_attrs)
    team_user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all team_users", %{conn: conn} do
      conn = get(conn, Routes.team_user_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create team_user" do
    test "renders team_user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.team_user_path(conn, :create), team_user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.team_user_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.team_user_path(conn, :create), team_user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update team_user" do
    setup [:create_team_user]

    test "renders team_user when data is valid", %{conn: conn, team_user: %TeamUser{id: id} = team_user} do
      conn = put(conn, Routes.team_user_path(conn, :update, team_user), team_user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.team_user_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, team_user: team_user} do
      conn = put(conn, Routes.team_user_path(conn, :update, team_user), team_user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete team_user" do
    setup [:create_team_user]

    test "deletes chosen team_user", %{conn: conn, team_user: team_user} do
      conn = delete(conn, Routes.team_user_path(conn, :delete, team_user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.team_user_path(conn, :show, team_user))
      end
    end
  end

  defp create_team_user(_) do
    team_user = fixture(:team_user)
    {:ok, team_user: team_user}
  end
end
