defmodule AuditorActivityWeb.WorkOrderChecklistController do
  use AuditorActivityWeb, :controller

  alias AuditorActivity.Generic
  alias AuditorActivity.Generic.WorkOrderChecklist

  action_fallback AuditorActivityWeb.FallbackController

  def index(conn, _params) do
    work_order_checklist = Generic.list_work_order_checklist()
    render(conn, "index.json", work_order_checklist: work_order_checklist)
  end

  def create(conn, %{"work_order_checklist" => work_order_checklist_params}) do
    with {:ok, %WorkOrderChecklist{} = work_order_checklist} <- Generic.create_work_order_checklist(work_order_checklist_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.work_order_checklist_path(conn, :show, work_order_checklist))
      |> render("show.json", work_order_checklist: work_order_checklist)
    end
  end

  def show(conn, %{"id" => id}) do
    work_order_checklist = Generic.get_work_order_checklist!(id)
    render(conn, "show.json", work_order_checklist: work_order_checklist)
  end

  def update(conn, %{"id" => id, "work_order_checklist" => work_order_checklist_params}) do
    work_order_checklist = Generic.get_work_order_checklist!(id)

    with {:ok, %WorkOrderChecklist{} = work_order_checklist} <- Generic.update_work_order_checklist(work_order_checklist, work_order_checklist_params) do
      render(conn, "show.json", work_order_checklist: work_order_checklist)
    end
  end

  def delete(conn, %{"id" => id}) do
    work_order_checklist = Generic.get_work_order_checklist!(id)

    with {:ok, %WorkOrderChecklist{}} <- Generic.delete_work_order_checklist(work_order_checklist) do
      send_resp(conn, :no_content, "")
    end
  end
end
