defmodule AuditorActivityWeb.ChecklistControllerTest do
  use AuditorActivityWeb.ConnCase

  alias AuditorActivity.Generic
  alias AuditorActivity.Generic.Checklist

  @create_attrs %{
    description: "some description",
    name: "some name",
    status: "some status",
    time_to_finish: "2010-04-17T14:00:00Z"
  }
  @update_attrs %{
    description: "some updated description",
    name: "some updated name",
    status: "some updated status",
    time_to_finish: "2011-05-18T15:01:01Z"
  }
  @invalid_attrs %{description: nil, name: nil, status: nil, time_to_finish: nil}

  def fixture(:checklist) do
    {:ok, checklist} = Generic.create_checklist(@create_attrs)
    checklist
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all checklists", %{conn: conn} do
      conn = get(conn, Routes.checklist_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create checklist" do
    test "renders checklist when data is valid", %{conn: conn} do
      conn = post(conn, Routes.checklist_path(conn, :create), checklist: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.checklist_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "name" => "some name",
               "status" => "some status",
               "time_to_finish" => "2010-04-17T14:00:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.checklist_path(conn, :create), checklist: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update checklist" do
    setup [:create_checklist]

    test "renders checklist when data is valid", %{conn: conn, checklist: %Checklist{id: id} = checklist} do
      conn = put(conn, Routes.checklist_path(conn, :update, checklist), checklist: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.checklist_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "name" => "some updated name",
               "status" => "some updated status",
               "time_to_finish" => "2011-05-18T15:01:01Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, checklist: checklist} do
      conn = put(conn, Routes.checklist_path(conn, :update, checklist), checklist: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete checklist" do
    setup [:create_checklist]

    test "deletes chosen checklist", %{conn: conn, checklist: checklist} do
      conn = delete(conn, Routes.checklist_path(conn, :delete, checklist))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.checklist_path(conn, :show, checklist))
      end
    end
  end

  defp create_checklist(_) do
    checklist = fixture(:checklist)
    {:ok, checklist: checklist}
  end
end
