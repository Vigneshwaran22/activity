defmodule AuditorActivityWeb.WorkOrderCheckpointController do
  use AuditorActivityWeb, :controller

  alias AuditorActivity.Generic
  alias AuditorActivity.Generic.WorkOrderCheckpoint

  action_fallback AuditorActivityWeb.FallbackController

  def index(conn, _params) do
    work_order_checkpoint = Generic.list_work_order_checkpoint()
    render(conn, "index.json", work_order_checkpoint: work_order_checkpoint)
  end

  def create(conn, %{"work_order_checkpoint" => work_order_checkpoint_params}) do
    with {:ok, %WorkOrderCheckpoint{} = work_order_checkpoint} <- Generic.create_work_order_checkpoint(work_order_checkpoint_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.work_order_checkpoint_path(conn, :show, work_order_checkpoint))
      |> render("show.json", work_order_checkpoint: work_order_checkpoint)
    end
  end

  def show(conn, %{"id" => id}) do
    work_order_checkpoint = Generic.get_work_order_checkpoint!(id)
    render(conn, "show.json", work_order_checkpoint: work_order_checkpoint)
  end

  def update(conn, %{"id" => id, "work_order_checkpoint" => work_order_checkpoint_params}) do
    work_order_checkpoint = Generic.get_work_order_checkpoint!(id)

    with {:ok, %WorkOrderCheckpoint{} = work_order_checkpoint} <- Generic.update_work_order_checkpoint(work_order_checkpoint, work_order_checkpoint_params) do
      render(conn, "show.json", work_order_checkpoint: work_order_checkpoint)
    end
  end

  def delete(conn, %{"id" => id}) do
    work_order_checkpoint = Generic.get_work_order_checkpoint!(id)

    with {:ok, %WorkOrderCheckpoint{}} <- Generic.delete_work_order_checkpoint(work_order_checkpoint) do
      send_resp(conn, :no_content, "")
    end
  end
end
