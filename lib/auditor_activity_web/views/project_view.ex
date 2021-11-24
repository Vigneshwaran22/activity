defmodule AuditorActivityWeb.ProjectView do
  use AuditorActivityWeb, :view
  alias AuditorActivityWeb.{ProjectView, EquipmentView, UserView}

  def render("index.json", %{projects: projects}) do
    %{
      projects: render_many(projects.entries, ProjectView, "projects.json"),
      page_number: projects.page_number,
      page_size: projects.page_size,
      total_entries: projects.total_entries,
      total_pages: projects.total_pages
    }
  end

  def render("show.json", %{project: project}) do
    %{data: render_one(project, ProjectView, "project.json")}
  end

  def render("projects.json", %{project: project}) do
    IO.inspect(project)

    %{
      id: project.id,
      name: project.name,
      type: project.type,
      start_date: project.start_date,
      end_date: project.end_date,
      status: project.status,
      equipment: project.equipment,
      project_type: project.project_type,
      team_template: project.team_template
    }
  end

  def render("project.json", %{project: project}) do
    IO.inspect(project)

    %{
      id: project.id,
      name: project.name,
      type: project.type,
      schedule_type: project.schedule_type,
      start_hour: project.start_hour,
      end_hour: project.end_hour,
      day_of_week: project.day_of_week,
      fortnite: project.fortnite,
      day_of_month: project.day_of_month,
      month: project.month,
      description: project.description,
      month2: project.month2,
      month3: project.month3,
      month4: project.month4,
      start_date: project.start_date,
      end_date: project.end_date,
      started_on: project.started_on,
      completed_on: project.completed_on,
      status: project.status,
      project_type_id: project.project_type_id,
      # case is_nil(project.project_type) do
      #   false -> project.project_type.id
      #   true -> nil
      # end,
      restricted: project.restricted,
      # equipment:
      #   case is_nil(project.equipment) do
      #     false -> render_one(project.equipment, EquipmentView, "equipment.json")
      #     true -> []
      #   end,
      equipment_id: project.equipment_id,
      # case is_nil(project.equipment) do
      #   false -> project.equipment.id
      #   true -> nil
      # end,
      users:
        case is_list(project.users) do
          true -> render_many(project.users, UserView, "user.json")
          false -> []
        end,
      team_template_id: project.team_template_id
    }
  end

  def render("workorder_project.json", %{project: project}) do
    %{
      id: project.id,
      name: project.name,
      type: project.type,
      schedule_type: project.schedule_type,
      start_hour: project.start_hour,
      end_hour: project.end_hour,
      status: project.status,
      equipment:
        case is_nil(project.equipment) do
          false -> render_one(project.equipment, EquipmentView, "equipment.json")
          true -> []
        end,
      equipment_id:
        case is_nil(project.equipment) do
          false -> project.equipment.id
          true -> nil
        end,
      users:
        case is_list(project.users) do
          true -> render_many(project.users, UserView, "user.json")
          false -> []
        end
    }
  end
end
