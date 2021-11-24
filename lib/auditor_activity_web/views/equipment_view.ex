defmodule AuditorActivityWeb.EquipmentView do
  use AuditorActivityWeb, :view
  alias AuditorActivityWeb.EquipmentView
  # alias AuditorActivityWeb.EquipmentCategoryView

  def render("index.json", %{equipments: equipments}) do
    %{
      equipments: render_many(equipments.entries, EquipmentView, "equipments.json"),
      page_number: equipments.page_number,
      page_size: equipments.page_size,
      total_entries: equipments.total_entries,
      total_pages: equipments.total_pages
    }
  end

  def render("show.json", %{equipment: equipment}) do
    %{data: render_one(equipment, EquipmentView, "equipment.json")}
  end

  def render("equipments.json", %{equipment: equipment}) do
    %{
      id: equipment.id,
      variant: equipment.variant,
      brand_name: equipment.brand_name,
      serial_no: equipment.serial_no,
      equipment_category: equipment.equipment_category
    }
  end

  def render("equipment.json", %{equipment: equipment}) do
    %{
      id: equipment.id,
      variant: equipment.variant,
      brand_name: equipment.brand_name,
      serial_no: equipment.serial_no,
      equipment_category_id: equipment.equipment_category_id
    }
  end
end
