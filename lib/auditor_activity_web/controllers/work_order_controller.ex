defmodule AuditorActivityWeb.WorkOrderController do
  use AuditorActivityWeb, :controller

  alias AuditorActivity.Projects
  alias AuditorActivity.Generic.WorkOrder

  action_fallback AuditorActivityWeb.FallbackController

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, %{
        "offset" => offset,
        "limit" => limit,
        "sort" => sort,
        "order" => order,
        "search" => search
      }) do
    work_orders = Projects.list_work_orders(offset, limit, sort, order, search)
    render(conn, "index.json", work_orders: work_orders)
  end

  def create(conn, %{"work_order" => work_order_params}) do
    with {:ok, %WorkOrder{} = work_order} <- Projects.create_work_order(work_order_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.work_order_path(conn, :show, work_order))
      |> render("show.json", work_order: work_order)
    end
  end

  def show(conn, %{"id" => id}) do
    work_order = Projects.get_work_order!(id)
    render(conn, "show.json", work_order: work_order)
  end

  def update(conn, %{"id" => id, "work_order" => work_order_params}) do
    work_order = Projects.get_work_order!(id)

    with {:ok, %WorkOrder{} = work_order} <-
           Projects.update_work_order(work_order, work_order_params) do
      render(conn, "show.json", work_order: work_order)
    end
  end

  def delete(conn, %{"id" => id}) do
    work_order = Projects.get_work_order!(id)

    with {:ok, %WorkOrder{}} <- Projects.delete_work_order(work_order) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_workorders(conn, _params) do
    work_orders = Projects.get_uncompleted_and_today_workorder()
    render(conn, "index.json", work_orders: work_orders)
  end

  def get_workorders_by_id(conn, %{"id" => id}) do
    work_order = Projects.get_uncompleted_and_today_workorder_by_id!(id)
    render(conn, "show.json", work_order: work_order)
  end

  def list_workorders_by_date_range(conn, %{
        "start_date" => start_date,
        "end_date" => end_date,
        "offset" => offset,
        "limit" => limit,
        "sort" => sort,
        "order" => order,
        "search" => search
      }) do
        start_date = if start_date == "null" do nil else Date.from_iso8601(start_date) |> elem(1) end
        end_date = if end_date == "null" do nil else Date.from_iso8601(end_date) |> elem(1) end
    render(conn, "index.json",
      work_orders:
        Projects.list_workorders_by_date_range(
          start_date,
          end_date,
          offset,
          limit,
          sort,
          order,
          search
        )
    )
  end
end
