defmodule AuditorActivityWeb.WorkOrderChecklistView do
  use AuditorActivityWeb, :view
  alias AuditorActivityWeb.{WorkOrderChecklistView, ChecklistView, WorkOrderCheckpointView}

  def render("index.json", %{work_order_checklist: work_order_checklist}) do
    %{data: render_many(work_order_checklist, WorkOrderChecklistView, "work_order_checklist.json")}
  end

  def render("show.json", %{work_order_checklist: work_order_checklist}) do
    %{data: render_one(work_order_checklist, WorkOrderChecklistView, "work_order_checklist_checkpoints.json")}
  end

  def render("work_order_checklist.json", %{work_order_checklist: work_order_checklist}) do
    %{id: work_order_checklist.id,
      status: work_order_checklist.status}
  end

  def render("work_order_checklist_checkpoints.json", %{work_order_checklist: work_order_checklist}) do
    %{id: work_order_checklist.id,
      status: work_order_checklist.status,
      work_order_checkpoints: 
      case is_list(work_order_checklist.work_order_checkpoints) do
        true -> render_many(work_order_checklist.work_order_checkpoints, WorkOrderCheckpointView, "work_order_checkpoints.json")
        false -> []
      end}
  end

  def render("work_order_checklists.json", %{work_order_checklist: work_order_checklist}) do
    %{id: work_order_checklist.id,
      status: work_order_checklist.status,
      checklist: render_one(work_order_checklist.checklist, ChecklistView, "workorder_checklist.json")}
  end
end
