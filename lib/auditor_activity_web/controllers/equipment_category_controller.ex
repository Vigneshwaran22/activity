defmodule AuditorActivityWeb.EquipmentCategoryController do
  use AuditorActivityWeb, :controller

  alias AuditorActivity.EquipmentSettings
  alias AuditorActivity.Generic.EquipmentCategory
  alias AuditorActivity.ProjectSettings

  action_fallback AuditorActivityWeb.FallbackController

  def index(conn, %{"offset" => offset, "limit" => limit, "sort" => sort, "order" => order, "search" => search}) do
    equipment_categories = EquipmentSettings.list_equipment_categories(offset, limit, sort, order, search)
    render(conn, "index.json", equipment_categories: equipment_categories)
  end

  def create(conn, %{"equipment_category" => equipment_category_params}) do
    with {:ok, %EquipmentCategory{} = equipment_category} <-
      EquipmentSettings.create_equipment_category(equipment_category_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.equipment_category_path(conn, :show, equipment_category)
      )
      |> render("show.json", equipment_category: equipment_category)
    end
  end

  def show(conn, %{"id" => id}) do
    equipment_category = EquipmentSettings.get_equipment_category!(id)
    render(conn, "show.json", equipment_category: equipment_category)
  end

  def update(conn, %{"id" => id, "equipment_category" => equipment_category_params}) do
    equipment_category = EquipmentSettings.get_equipment_category!(id)

    with {:ok, %EquipmentCategory{} = equipment_category} <-
      EquipmentSettings.update_equipment_category(equipment_category, equipment_category_params) do
      render(conn, "show.json", equipment_category: equipment_category)
    end
  end

  def delete(conn, %{"id" => id}) do
    equipment_category = EquipmentSettings.get_equipment_category!(id)

    with {:ok, %EquipmentCategory{}} <- EquipmentSettings.delete_equipment_category(equipment_category) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_equipments_by_equipment_category_id(conn, %{"id" => id}) do
    project_type = ProjectSettings.get_project_type!(id)
    equipment_category = EquipmentSettings.get_equipment_category!(project_type.equipment_category_id)
    render(conn, "equipments.json", equipment_category: equipment_category)
  end
end
