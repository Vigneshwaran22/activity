defmodule AuditorActivityWeb.ProjectTypeControllerTest do
  use AuditorActivityWeb.ConnCase

  alias AuditorActivity.Generic
  alias AuditorActivity.Generic.ProjectType

  @create_attrs %{
    description: "some description",
    name: "some name"
  }
  @update_attrs %{
    description: "some updated description",
    name: "some updated name"
  }
  @invalid_attrs %{description: nil, name: nil}

  def fixture(:project_type) do
    {:ok, project_type} = Generic.create_project_type(@create_attrs)
    project_type
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all project_types", %{conn: conn} do
      conn = get(conn, Routes.project_type_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create project_type" do
    test "renders project_type when data is valid", %{conn: conn} do
      conn = post(conn, Routes.project_type_path(conn, :create), project_type: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.project_type_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.project_type_path(conn, :create), project_type: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update project_type" do
    setup [:create_project_type]

    test "renders project_type when data is valid", %{conn: conn, project_type: %ProjectType{id: id} = project_type} do
      conn = put(conn, Routes.project_type_path(conn, :update, project_type), project_type: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.project_type_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, project_type: project_type} do
      conn = put(conn, Routes.project_type_path(conn, :update, project_type), project_type: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete project_type" do
    setup [:create_project_type]

    test "deletes chosen project_type", %{conn: conn, project_type: project_type} do
      conn = delete(conn, Routes.project_type_path(conn, :delete, project_type))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.project_type_path(conn, :show, project_type))
      end
    end
  end

  defp create_project_type(_) do
    project_type = fixture(:project_type)
    {:ok, project_type: project_type}
  end
end
