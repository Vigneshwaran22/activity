defmodule AuditorActivityWeb.ChecklistView do
  use AuditorActivityWeb, :view
  alias AuditorActivityWeb.{ChecklistView, CheckpointView}

  def render("index.json", %{checklists: checklists}) do
    %{
      checklists: render_many(checklists.entries, ChecklistView, "checklists.json"),
      page_number: checklists.page_number,
      page_size: checklists.page_size,
      total_entries: checklists.total_entries,
      total_pages: checklists.total_pages
    }
  end

  def render("show.json", %{checklist: checklist}) do
    %{data: render_one(checklist, ChecklistView, "checklist.json")}
  end

  def render("checklists.json", %{checklist: checklist}) do
    %{
      id: checklist.id,
      name: checklist.name,
      description: checklist.description,
      active_status: checklist.active_status,
      checkpoints:
        case is_list(checklist.checkpoints) do
          true -> render_many(checklist.checkpoints, CheckpointView, "checkpoint.json")
          false -> []
        end
    }
  end

  def render("checklist.json", %{checklist: checklist}) do
    %{
      id: checklist.id,
      name: checklist.name,
      description: checklist.description,
      active_status: checklist.active_status,
      # task_id: checklist.task_id,
      checkpoints:
        case is_list(checklist.checkpoints) do
          true -> render_many(checklist.checkpoints, CheckpointView, "checkpoint.json")
          false -> []
        end
    }
  end

  def render("workorder_checklist.json", %{checklist: checklist}) do
    %{
      id: checklist.id,
      name: checklist.name,
      description: checklist.description,
      active_status: checklist.active_status
    }
  end
end
