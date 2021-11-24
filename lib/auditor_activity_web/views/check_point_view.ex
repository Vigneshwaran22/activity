defmodule AuditorActivityWeb.CheckpointView do
  use AuditorActivityWeb, :view
  alias AuditorActivityWeb.CheckpointView

  def render("index.json", %{checkpoints: checkpoints}) do
    %{data: render_many(checkpoints, CheckpointView, "checkpoint.json")}
  end

  def render("show.json", %{checkpoint: checkpoint}) do
    %{data: render_one(checkpoint, CheckpointView, "checkpoint.json")}
  end

  def render("checkpoint.json", %{checkpoint: checkpoint}) do
    %{
      id: checkpoint.id, 
      name: checkpoint.name,
      type: checkpoint.type,
      options: checkpoint.options,
      sub_type: checkpoint.sub_type,
      status: checkpoint.status
  }
  end
end
