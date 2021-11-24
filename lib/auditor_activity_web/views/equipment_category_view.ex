defmodule AuditorActivityWeb.EquipmentCategoryView do
  use AuditorActivityWeb, :view
  alias AuditorActivityWeb.EquipmentCategoryView
  
  def render("index.json", %{equipment_categories: equipment_categories}) do
    %{
      equipment_categories:
        render_many(
          equipment_categories.entries,
          EquipmentCategoryView,
          "equipment_category.json"
        ),
      page_number: equipment_categories.page_number,
      page_size: equipment_categories.page_size,
      total_entries: equipment_categories.total_entries,
      total_pages: equipment_categories.total_pages
    }
  end

  def render("show.json", %{equipment_category: equipment_category}) do
    %{data: render_one(equipment_category, EquipmentCategoryView, "equipment_category.json")}
  end

  def render("equipments.json", %{equipment_category: equipment_category}) do
    %{
      equipment_category_name: equipment_category.name,
      equipments:
        Enum.map(equipment_category.equipments, fn equipment ->
          %{id: equipment.id, brand_name: equipment.brand_name, variant: equipment.variant}
        end)
    }
  end

  def render("equipment_category.json", %{equipment_category: equipment_category}) do
    %{id: equipment_category.id, name: equipment_category.name}
  end
end
