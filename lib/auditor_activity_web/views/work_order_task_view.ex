defmodule AuditorActivityWeb.WorkOrderTaskView do
  use AuditorActivityWeb, :view
  alias AuditorActivityWeb.{WorkOrderTaskView, TaskView, WorkOrderChecklistView}

  def render("index.json", %{work_order_tasks: work_order_tasks}) do
    %{data: render_many(work_order_tasks, WorkOrderTaskView, "work_order_task.json")}
  end

  def render("show.json", %{work_order_task: work_order_task}) do
    %{data: render_one(work_order_task, WorkOrderTaskView, "work_order_task.json")}
  end

  def render("work_order_task.json", %{work_order_task: work_order_task}) do
    %{id: work_order_task.id,
      status: work_order_task.status,
      start_date: work_order_task.start_date,
      end_date: work_order_task.end_date,
      started_on: work_order_task.started_on,
      completed_on: work_order_task.completed_on,
      time_to_finish: work_order_task.time_to_finish,
      task: render_one(work_order_task.task, TaskView, "tasks.json"),
      work_order_checklists: 
        case is_list(work_order_task.work_order_checklists) do
          true -> render_many(work_order_task.work_order_checklists, WorkOrderChecklistView, "work_order_checklists.json")
          false -> []
        end
      }
  end

  def render("work_orders_task.json", %{work_order_task: work_order_task}) do
    %{id: work_order_task.id,
      status: work_order_task.status,
      start_date: work_order_task.start_date,
      end_date: work_order_task.end_date,
      started_on: work_order_task.started_on,
      completed_on: work_order_task.completed_on,
      time_to_finish: work_order_task.time_to_finish,
      task: render_one(work_order_task.task, TaskView, "tasks.json")
      }
  end
end
