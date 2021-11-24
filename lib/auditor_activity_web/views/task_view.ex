defmodule AuditorActivityWeb.TaskView do
  use AuditorActivityWeb, :view
  alias AuditorActivityWeb.{TaskView, ChecklistView}

  # alias AuditorActivityWeb.ChecklistView

  def render("index.json", %{tasks: tasks}) do
    %{
      tasks: render_many(tasks.entries, TaskView, "tasks.json"),
      page_number: tasks.page_number,
      page_size: tasks.page_size,
      total_entries: tasks.total_entries,
      total_pages: tasks.total_pages
    }
  end

  def render("show.json", %{task: task}) do
    %{data: render_one(task, TaskView, "task.json")}
  end

  def render("tasks.json", %{task: task}) do
    %{
      id: task.id,
      name: task.name,
      description: task.description,
      time_to_finish: task.time_to_finish
    }
  end

  def render("task.json", %{task: task}) do
    %{
      id: task.id,
      name: task.name,
      description: task.description,
      time_to_finish: task.time_to_finish,
      type: task.type,
      checklists:
        case is_list(task.checklists) do
          true -> render_many(task.checklists, ChecklistView, "workorder_checklist.json")
          false -> []
        end
    }
  end
end
