defmodule AuditorActivityWeb.WorkOrderCheckpointView do
  use AuditorActivityWeb, :view
  alias AuditorActivityWeb.{WorkOrderCheckpointView, CheckpointView}

  def render("index.json", %{work_order_checkpoint: work_order_checkpoint}) do
    %{data: render_many(work_order_checkpoint, WorkOrderCheckpointView, "work_order_checkpoint.json")}
  end

  def render("show.json", %{work_order_checkpoint: work_order_checkpoint}) do
    %{data: render_one(work_order_checkpoint, WorkOrderCheckpointView, "work_order_checkpoint.json")}
  end 

  def render("work_order_checkpoints.json", %{work_order_checkpoint: work_order_checkpoint}) do
    %{id: work_order_checkpoint.id,
      status: work_order_checkpoint.status,
      value: work_order_checkpoint.value,
      check_value: work_order_checkpoint.check_value,
      selected_value: work_order_checkpoint.selected_value,
      checkpoint: render_one(work_order_checkpoint.checkpoint, CheckpointView, "checkpoint.json")
    }
  end

  def render("work_order_checkpoint.json", %{work_order_checkpoint: work_order_checkpoint}) do
    %{id: work_order_checkpoint.id,
      status: work_order_checkpoint.status}
  end
end
