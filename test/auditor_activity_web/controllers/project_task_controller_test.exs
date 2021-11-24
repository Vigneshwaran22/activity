defmodule AuditorActivityWeb.ProjecttypeTaskControllerTest do
  use AuditorActivityWeb.ConnCase

  alias AuditorActivity.Generic
  alias AuditorActivity.Generic.ProjecttypeTask

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:project_task) do
    {:ok, project_task} = Generic.create_project_task(@create_attrs)
    project_task
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all project_tasks", %{conn: conn} do
      conn = get(conn, Routes.project_task_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create project_task" do
    test "renders project_task when data is valid", %{conn: conn} do
      conn = post(conn, Routes.project_task_path(conn, :create), project_task: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.project_task_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.project_task_path(conn, :create), project_task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update project_task" do
    setup [:create_project_task]

    test "renders project_task when data is valid", %{conn: conn, project_task: %ProjecttypeTask{id: id} = project_task} do
      conn = put(conn, Routes.project_task_path(conn, :update, project_task), project_task: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.project_task_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, project_task: project_task} do
      conn = put(conn, Routes.project_task_path(conn, :update, project_task), project_task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete project_task" do
    setup [:create_project_task]

    test "deletes chosen project_task", %{conn: conn, project_task: project_task} do
      conn = delete(conn, Routes.project_task_path(conn, :delete, project_task))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.project_task_path(conn, :show, project_task))
      end
    end
  end

  defp create_project_task(_) do
    project_task = fixture(:project_task)
    {:ok, project_task: project_task}
  end
end
