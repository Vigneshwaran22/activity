defmodule AuditorActivityWeb.UserTaskControllerTest do
  use AuditorActivityWeb.ConnCase

  alias AuditorActivity.Generic
  alias AuditorActivity.Generic.UserTask

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:user_task) do
    {:ok, user_task} = Generic.create_user_task(@create_attrs)
    user_task
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all user_tasks", %{conn: conn} do
      conn = get(conn, Routes.user_task_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user_task" do
    test "renders user_task when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_task_path(conn, :create), user_task: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_task_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_task_path(conn, :create), user_task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user_task" do
    setup [:create_user_task]

    test "renders user_task when data is valid", %{conn: conn, user_task: %UserTask{id: id} = user_task} do
      conn = put(conn, Routes.user_task_path(conn, :update, user_task), user_task: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_task_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user_task: user_task} do
      conn = put(conn, Routes.user_task_path(conn, :update, user_task), user_task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user_task" do
    setup [:create_user_task]

    test "deletes chosen user_task", %{conn: conn, user_task: user_task} do
      conn = delete(conn, Routes.user_task_path(conn, :delete, user_task))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_task_path(conn, :show, user_task))
      end
    end
  end

  defp create_user_task(_) do
    user_task = fixture(:user_task)
    {:ok, user_task: user_task}
  end
end
