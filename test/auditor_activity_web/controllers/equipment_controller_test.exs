defmodule AuditorActivityWeb.EquipmentControllerTest do
  use AuditorActivityWeb.ConnCase

  alias AuditorActivity.Generic
  alias AuditorActivity.Generic.Equipment

  @create_attrs %{
     name: "some  name",
    brand_name: "some brand_name",
    serial_no: "some serial_no"
  }
  @update_attrs %{
     name: "some updated  name",
    brand_name: "some updated brand_name",
    serial_no: "some updated serial_no"
  }
  @invalid_attrs %{" name": nil, brand_name: nil, serial_no: nil}

  def fixture(:equipment) do
    {:ok, equipment} = Generic.create_equipment(@create_attrs)
    equipment
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all equipments", %{conn: conn} do
      conn = get(conn, Routes.equipment_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create equipment" do
    test "renders equipment when data is valid", %{conn: conn} do
      conn = post(conn, Routes.equipment_path(conn, :create), equipment: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.equipment_path(conn, :show, id))

      assert %{
               "id" => id,
               " name" => "some  name",
               "brand_name" => "some brand_name",
               "serial_no" => "some serial_no"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.equipment_path(conn, :create), equipment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update equipment" do
    setup [:create_equipment]

    test "renders equipment when data is valid", %{conn: conn, equipment: %Equipment{id: id} = equipment} do
      conn = put(conn, Routes.equipment_path(conn, :update, equipment), equipment: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.equipment_path(conn, :show, id))

      assert %{
               "id" => id,
               " name" => "some updated  name",
               "brand_name" => "some updated brand_name",
               "serial_no" => "some updated serial_no"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, equipment: equipment} do
      conn = put(conn, Routes.equipment_path(conn, :update, equipment), equipment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete equipment" do
    setup [:create_equipment]

    test "deletes chosen equipment", %{conn: conn, equipment: equipment} do
      conn = delete(conn, Routes.equipment_path(conn, :delete, equipment))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.equipment_path(conn, :show, equipment))
      end
    end
  end

  defp create_equipment(_) do
    equipment = fixture(:equipment)
    {:ok, equipment: equipment}
  end
end
