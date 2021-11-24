defmodule AuditorActivityWeb.ShiftTimeControllerTest do
  use AuditorActivityWeb.ConnCase

  alias AuditorActivity.Generic
  alias AuditorActivity.Generic.ShiftTime

  @create_attrs %{
     name: "some  name",
    end_time: ~T[14:00:00],
    start_time: ~T[14:00:00]
  }
  @update_attrs %{
     name: "some updated  name",
    end_time: ~T[15:01:01],
    start_time: ~T[15:01:01]
  }
  @invalid_attrs %{" name": nil, end_time: nil, start_time: nil}

  def fixture(:shift_time) do
    {:ok, shift_time} = Generic.create_shift_time(@create_attrs)
    shift_time
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all shift_times", %{conn: conn} do
      conn = get(conn, Routes.shift_time_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create shift_time" do
    test "renders shift_time when data is valid", %{conn: conn} do
      conn = post(conn, Routes.shift_time_path(conn, :create), shift_time: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.shift_time_path(conn, :show, id))

      assert %{
               "id" => id,
               " name" => "some  name",
               "end_time" => "14:00:00",
               "start_time" => "14:00:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.shift_time_path(conn, :create), shift_time: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update shift_time" do
    setup [:create_shift_time]

    test "renders shift_time when data is valid", %{conn: conn, shift_time: %ShiftTime{id: id} = shift_time} do
      conn = put(conn, Routes.shift_time_path(conn, :update, shift_time), shift_time: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.shift_time_path(conn, :show, id))

      assert %{
               "id" => id,
               " name" => "some updated  name",
               "end_time" => "15:01:01",
               "start_time" => "15:01:01"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, shift_time: shift_time} do
      conn = put(conn, Routes.shift_time_path(conn, :update, shift_time), shift_time: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete shift_time" do
    setup [:create_shift_time]

    test "deletes chosen shift_time", %{conn: conn, shift_time: shift_time} do
      conn = delete(conn, Routes.shift_time_path(conn, :delete, shift_time))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.shift_time_path(conn, :show, shift_time))
      end
    end
  end

  defp create_shift_time(_) do
    shift_time = fixture(:shift_time)
    {:ok, shift_time: shift_time}
  end
end
