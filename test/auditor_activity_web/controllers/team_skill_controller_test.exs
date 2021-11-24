defmodule AuditorActivityWeb.TeamSkillControllerTest do
  use AuditorActivityWeb.ConnCase

  alias AuditorActivity.Generic
  alias AuditorActivity.Generic.TeamSkill

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:team_skill) do
    {:ok, team_skill} = Generic.create_team_skill(@create_attrs)
    team_skill
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all team_skills", %{conn: conn} do
      conn = get(conn, Routes.team_skill_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create team_skill" do
    test "renders team_skill when data is valid", %{conn: conn} do
      conn = post(conn, Routes.team_skill_path(conn, :create), team_skill: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.team_skill_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.team_skill_path(conn, :create), team_skill: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update team_skill" do
    setup [:create_team_skill]

    test "renders team_skill when data is valid", %{conn: conn, team_skill: %TeamSkill{id: id} = team_skill} do
      conn = put(conn, Routes.team_skill_path(conn, :update, team_skill), team_skill: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.team_skill_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, team_skill: team_skill} do
      conn = put(conn, Routes.team_skill_path(conn, :update, team_skill), team_skill: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete team_skill" do
    setup [:create_team_skill]

    test "deletes chosen team_skill", %{conn: conn, team_skill: team_skill} do
      conn = delete(conn, Routes.team_skill_path(conn, :delete, team_skill))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.team_skill_path(conn, :show, team_skill))
      end
    end
  end

  defp create_team_skill(_) do
    team_skill = fixture(:team_skill)
    {:ok, team_skill: team_skill}
  end
end
