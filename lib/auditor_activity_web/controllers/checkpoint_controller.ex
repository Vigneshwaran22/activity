defmodule AuditorActivityWeb.CheckpointController do
  use AuditorActivityWeb, :controller

  alias AuditorActivity.TaskSettings 
  alias AuditorActivity.Generic.Checkpoint

  action_fallback AuditorActivityWeb.FallbackController

  def index(conn, _params) do
    checkpoints = TaskSettings.list_checkpoints()
    render(conn, "index.json", checkpoints: checkpoints)
  end

  def create(conn, %{"checkpoint" => checkpoint_params}) do
    with {:ok, %Checkpoint{} = checkpoint} <- TaskSettings.create_checkpoint(checkpoint_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.checkpoint_path(conn, :show, checkpoint))
      |> render("show.json", checkpoint: checkpoint)
    end
  end

  def show(conn, %{"id" => id}) do
    checkpoint = TaskSettings.get_checkpoint!(id)
    render(conn, "show.json", checkpoint: checkpoint)
  end

  def update(conn, %{"id" => id, "checkpoint" => checkpoint_params}) do
    checkpoint = TaskSettings.get_checkpoint!(id)

    with {:ok, %Checkpoint{} = checkpoint} <- TaskSettings.update_checkpoint(checkpoint, checkpoint_params) do
      render(conn, "show.json", checkpoint: checkpoint)
    end
  end

  def delete(conn, %{"id" => id}) do
    checkpoint = TaskSettings.get_checkpoint!(id)

    with {:ok, %Checkpoint{}} <- TaskSettings.delete_checkpoint(checkpoint) do
      send_resp(conn, :no_content, "")
    end
  end
end
