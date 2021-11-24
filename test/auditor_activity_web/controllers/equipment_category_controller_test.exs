defmodule AuditorActivityWeb.EquipmentCategoryControllerTest do
  use AuditorActivityWeb.ConnCase

  alias AuditorActivity.Generic
  alias AuditorActivity.Generic.EquipmentCategory

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:equipment_category) do
    {:ok, equipment_category} = Generic.create_equipment_category(@create_attrs)
    equipment_category
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all equipment_categories", %{conn: conn} do
      conn = get(conn, Routes.equipment_category_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create equipment_category" do
    test "renders equipment_category when data is valid", %{conn: conn} do
      conn = post(conn, Routes.equipment_category_path(conn, :create), equipment_category: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.equipment_category_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.equipment_category_path(conn, :create), equipment_category: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update equipment_category" do
    setup [:create_equipment_category]

    test "renders equipment_category when data is valid", %{conn: conn, equipment_category: %EquipmentCategory{id: id} = equipment_category} do
      conn = put(conn, Routes.equipment_category_path(conn, :update, equipment_category), equipment_category: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.equipment_category_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, equipment_category: equipment_category} do
      conn = put(conn, Routes.equipment_category_path(conn, :update, equipment_category), equipment_category: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete equipment_category" do
    setup [:create_equipment_category]

    test "deletes chosen equipment_category", %{conn: conn, equipment_category: equipment_category} do
      conn = delete(conn, Routes.equipment_category_path(conn, :delete, equipment_category))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.equipment_category_path(conn, :show, equipment_category))
      end
    end
  end

  defp create_equipment_category(_) do
    equipment_category = fixture(:equipment_category)
    {:ok, equipment_category: equipment_category}
  end
end
