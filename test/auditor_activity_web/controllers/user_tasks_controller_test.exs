defmodule AuditorActivityWeb.UserProjectControllerTest do
  use AuditorActivityWeb.ConnCase

  alias AuditorActivity.Generic
  alias AuditorActivity.Generic.UserProject

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:user_tasks) do
    {:ok, user_tasks} = Generic.create_user_tasks(@create_attrs)
    user_tasks
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all user_tasks", %{conn: conn} do
      conn = get(conn, Routes.user_tasks_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user_tasks" do
    test "renders user_tasks when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_tasks_path(conn, :create), user_tasks: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_tasks_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_tasks_path(conn, :create), user_tasks: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user_tasks" do
    setup [:create_user_tasks]

    test "renders user_tasks when data is valid", %{conn: conn, user_tasks: %UserProject{id: id} = user_tasks} do
      conn = put(conn, Routes.user_tasks_path(conn, :update, user_tasks), user_tasks: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_tasks_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user_tasks: user_tasks} do
      conn = put(conn, Routes.user_tasks_path(conn, :update, user_tasks), user_tasks: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user_tasks" do
    setup [:create_user_tasks]

    test "deletes chosen user_tasks", %{conn: conn, user_tasks: user_tasks} do
      conn = delete(conn, Routes.user_tasks_path(conn, :delete, user_tasks))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_tasks_path(conn, :show, user_tasks))
      end
    end
  end

  defp create_user_tasks(_) do
    user_tasks = fixture(:user_tasks)
    {:ok, user_tasks: user_tasks}
  end
end
