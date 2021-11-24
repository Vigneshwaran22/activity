defmodule AuditorActivityWeb.ProjectTypeView do
  use AuditorActivityWeb, :view
  alias AuditorActivityWeb.ProjectTypeView

  def render("index.json", %{project_types: project_types}) do
    %{
      project_types: render_many(project_types.entries, ProjectTypeView, "project_types.json"),
      page_number: project_types.page_number,
      page_size: project_types.page_size,
      total_entries: project_types.total_entries,
      total_pages: project_types.total_pages
    }
  end

  def render("show.json", %{project_type: project_type}) do
    %{data: render_one(project_type, ProjectTypeView, "project_type.json")}
  end

  def render("project_types.json", %{project_type: project_type}) do
    %{
      id: project_type.id,
      name: project_type.name,
      equipment_category: project_type.equipment_category
    }
  end

  def render("project_type.json", %{project_type: project_type}) do
    %{
      id: project_type.id,
      name: project_type.name,
      description: project_type.description,
      equipment_category_id: project_type.equipment_category_id,
      tasks: project_type.tasks
      # case is_list(project_type.tasks) do
      #   true ->
      #     Enum.map(project_type.tasks, fn task ->
      #       %{id: task.id, name: task.name}
      #     end)

      #   false ->
      #     []
      # end
    }
  end
end
