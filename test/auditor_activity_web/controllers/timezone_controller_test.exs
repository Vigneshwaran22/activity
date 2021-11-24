defmodule AuditorActivityWeb.TimezoneControllerTest do
  use AuditorActivityWeb.ConnCase

  alias AuditorActivity.Generic
  alias AuditorActivity.Generic.Timezone

  @create_attrs %{
     city: "some  city",
    city_low: "some city_low",
    city_stripped: "some city_stripped",
    continent: "some continent",
    label: "some label",
    offset: "some offset",
    state: "some state",
    utc_offset_seconds: 42
  }
  @update_attrs %{
     city: "some updated  city",
    city_low: "some updated city_low",
    city_stripped: "some updated city_stripped",
    continent: "some updated continent",
    label: "some updated label",
    offset: "some updated offset",
    state: "some updated state",
    utc_offset_seconds: 43
  }
  @invalid_attrs %{" city": nil, city_low: nil, city_stripped: nil, continent: nil, label: nil, offset: nil, state: nil, utc_offset_seconds: nil}

  def fixture(:timezone) do
    {:ok, timezone} = Generic.create_timezone(@create_attrs)
    timezone
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all timezones", %{conn: conn} do
      conn = get(conn, Routes.timezone_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create timezone" do
    test "renders timezone when data is valid", %{conn: conn} do
      conn = post(conn, Routes.timezone_path(conn, :create), timezone: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.timezone_path(conn, :show, id))

      assert %{
               "id" => id,
               " city" => "some  city",
               "city_low" => "some city_low",
               "city_stripped" => "some city_stripped",
               "continent" => "some continent",
               "label" => "some label",
               "offset" => "some offset",
               "state" => "some state",
               "utc_offset_seconds" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.timezone_path(conn, :create), timezone: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update timezone" do
    setup [:create_timezone]

    test "renders timezone when data is valid", %{conn: conn, timezone: %Timezone{id: id} = timezone} do
      conn = put(conn, Routes.timezone_path(conn, :update, timezone), timezone: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.timezone_path(conn, :show, id))

      assert %{
               "id" => id,
               " city" => "some updated  city",
               "city_low" => "some updated city_low",
               "city_stripped" => "some updated city_stripped",
               "continent" => "some updated continent",
               "label" => "some updated label",
               "offset" => "some updated offset",
               "state" => "some updated state",
               "utc_offset_seconds" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, timezone: timezone} do
      conn = put(conn, Routes.timezone_path(conn, :update, timezone), timezone: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete timezone" do
    setup [:create_timezone]

    test "deletes chosen timezone", %{conn: conn, timezone: timezone} do
      conn = delete(conn, Routes.timezone_path(conn, :delete, timezone))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.timezone_path(conn, :show, timezone))
      end
    end
  end

  defp create_timezone(_) do
    timezone = fixture(:timezone)
    {:ok, timezone: timezone}
  end
end
