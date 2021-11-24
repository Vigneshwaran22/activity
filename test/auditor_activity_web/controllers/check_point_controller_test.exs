defmodule AuditorActivityWeb.CheckpointControllerTest do
  use AuditorActivityWeb.ConnCase

  alias AuditorActivity.Generic
  alias AuditorActivity.Generic.Checkpoint

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:checkpoint) do
    {:ok, checkpoint} = Generic.create_checkpoint(@create_attrs)
    checkpoint
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all checkpoints", %{conn: conn} do
      conn = get(conn, Routes.checkpoint_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create checkpoint" do
    test "renders checkpoint when data is valid", %{conn: conn} do
      conn = post(conn, Routes.checkpoint_path(conn, :create), checkpoint: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.checkpoint_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.checkpoint_path(conn, :create), checkpoint: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update checkpoint" do
    setup [:create_checkpoint]

    test "renders checkpoint when data is valid", %{conn: conn, checkpoint: %Checkpoint{id: id} = checkpoint} do
      conn = put(conn, Routes.checkpoint_path(conn, :update, checkpoint), checkpoint: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.checkpoint_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, checkpoint: checkpoint} do
      conn = put(conn, Routes.checkpoint_path(conn, :update, checkpoint), checkpoint: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete checkpoint" do
    setup [:create_checkpoint]

    test "deletes chosen checkpoint", %{conn: conn, checkpoint: checkpoint} do
      conn = delete(conn, Routes.checkpoint_path(conn, :delete, checkpoint))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.checkpoint_path(conn, :show, checkpoint))
      end
    end
  end

  defp create_checkpoint(_) do
    checkpoint = fixture(:checkpoint)
    {:ok, checkpoint: checkpoint}
  end
end
