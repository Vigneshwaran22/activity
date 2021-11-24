defmodule AuditorActivityWeb.WorkOrderView do
  use AuditorActivityWeb, :view
  alias AuditorActivityWeb.WorkOrderView
  alias AuditorActivityWeb.{ProjectView, WorkOrderTaskView}

  def render("index.json", %{work_orders: work_orders}) do
    %{
      work_orders: render_many(work_orders.entries, WorkOrderView, "work_orders.json"),
      page_number: work_orders.page_number,
      page_size: work_orders.page_size,
      total_entries: work_orders.total_entries,
      total_pages: work_orders.total_pages
    }
  end

  def render("show.json", %{work_order: work_order}) do
    %{data: render_one(work_order, WorkOrderView, "work_order.json")}
  end

  def render("work_order.json", %{work_order: work_order}) do
    %{
      id: work_order.id,
      work_order_date: work_order.work_order_date,
      start_time: work_order.start_time,
      status: work_order.status,
      project: render_one(work_order.project, ProjectView, "workorder_project.json"),
      work_order_tasks:
        case is_list(work_order.work_order_tasks) do
          true ->
            render_many(work_order.work_order_tasks, WorkOrderTaskView, "work_orders_task.json")

          false ->
            []
        end
    }
  end

  def render("work_orders.json", %{work_order: work_order}) do
    %{
      id: work_order.id,
      project: work_order.project,
      equipment: work_order.equipment,
      type: work_order.type,
      schedule_type: work_order.schedule_type,
      work_order_date: work_order.work_order_date,
      start_time: work_order.start_time,
      status: work_order.status,
      # users: render_many(work_order.project.users, UserView, "user.json")
    }
  end
end
