defmodule AuditorActivityWeb.WorkOrderTaskController do
  use AuditorActivityWeb, :controller

  alias AuditorActivity.Generic
  alias AuditorActivity.Generic.WorkOrderTask

  action_fallback AuditorActivityWeb.FallbackController

  def index(conn, _params) do
    work_order_tasks = Generic.list_work_order_tasks()
    render(conn, "index.json", work_order_tasks: work_order_tasks)
  end

  def create(conn, %{"work_order_task" => work_order_task_params}) do
    with {:ok, %WorkOrderTask{} = work_order_task} <- Generic.create_work_order_task(work_order_task_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.work_order_task_path(conn, :show, work_order_task))
      |> render("show.json", work_order_task: work_order_task)
    end
  end

  def show(conn, %{"id" => id}) do
    work_order_task = Generic.get_work_order_task!(id)
    render(conn, "show.json", work_order_task: work_order_task)
  end

  def update(conn, %{"id" => id, "work_order_task" => work_order_task_params}) do
    work_order_task = Generic.get_work_order_task!(id)

    with {:ok, %WorkOrderTask{} = work_order_task} <- Generic.update_work_order_task(work_order_task, work_order_task_params) do
      render(conn, "show.json", work_order_task: work_order_task)
    end
  end

  def delete(conn, %{"id" => id}) do
    work_order_task = Generic.get_work_order_task!(id)

    with {:ok, %WorkOrderTask{}} <- Generic.delete_work_order_task(work_order_task) do
      send_resp(conn, :no_content, "")
    end
  end
end
