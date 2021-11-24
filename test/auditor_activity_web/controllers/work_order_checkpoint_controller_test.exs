defmodule AuditorActivityWeb.WorkOrderCheckpointControllerTest do
  use AuditorActivityWeb.ConnCase

  alias AuditorActivity.Generic
  alias AuditorActivity.Generic.WorkOrderCheckpoint

  @create_attrs %{
    status: "some status"
  }
  @update_attrs %{
    status: "some updated status"
  }
  @invalid_attrs %{status: nil}

  def fixture(:work_order_checkpoint) do
    {:ok, work_order_checkpoint} = Generic.create_work_order_checkpoint(@create_attrs)
    work_order_checkpoint
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all work_order_checkpoint", %{conn: conn} do
      conn = get(conn, Routes.work_order_checkpoint_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create work_order_checkpoint" do
    test "renders work_order_checkpoint when data is valid", %{conn: conn} do
      conn = post(conn, Routes.work_order_checkpoint_path(conn, :create), work_order_checkpoint: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.work_order_checkpoint_path(conn, :show, id))

      assert %{
               "id" => id,
               "status" => "some status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.work_order_checkpoint_path(conn, :create), work_order_checkpoint: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update work_order_checkpoint" do
    setup [:create_work_order_checkpoint]

    test "renders work_order_checkpoint when data is valid", %{conn: conn, work_order_checkpoint: %WorkOrderCheckpoint{id: id} = work_order_checkpoint} do
      conn = put(conn, Routes.work_order_checkpoint_path(conn, :update, work_order_checkpoint), work_order_checkpoint: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.work_order_checkpoint_path(conn, :show, id))

      assert %{
               "id" => id,
               "status" => "some updated status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, work_order_checkpoint: work_order_checkpoint} do
      conn = put(conn, Routes.work_order_checkpoint_path(conn, :update, work_order_checkpoint), work_order_checkpoint: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete work_order_checkpoint" do
    setup [:create_work_order_checkpoint]

    test "deletes chosen work_order_checkpoint", %{conn: conn, work_order_checkpoint: work_order_checkpoint} do
      conn = delete(conn, Routes.work_order_checkpoint_path(conn, :delete, work_order_checkpoint))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.work_order_checkpoint_path(conn, :show, work_order_checkpoint))
      end
    end
  end

  defp create_work_order_checkpoint(_) do
    work_order_checkpoint = fixture(:work_order_checkpoint)
    {:ok, work_order_checkpoint: work_order_checkpoint}
  end
end
