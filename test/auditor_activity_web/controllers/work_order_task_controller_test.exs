defmodule AuditorActivityWeb.WorkOrderTaskControllerTest do
  use AuditorActivityWeb.ConnCase

  alias AuditorActivity.Generic
  alias AuditorActivity.Generic.WorkOrderTask

  @create_attrs %{
    completed_on: "2010-04-17T14:00:00Z",
    end_date: ~D[2010-04-17],
    start_date: ~D[2010-04-17],
    started_on: "2010-04-17T14:00:00Z",
    status: "some status",
    time_to_finish: "2010-04-17T14:00:00Z"
  }
  @update_attrs %{
    completed_on: "2011-05-18T15:01:01Z",
    end_date: ~D[2011-05-18],
    start_date: ~D[2011-05-18],
    started_on: "2011-05-18T15:01:01Z",
    status: "some updated status",
    time_to_finish: "2011-05-18T15:01:01Z"
  }
  @invalid_attrs %{completed_on: nil, end_date: nil, start_date: nil, started_on: nil, status: nil, time_to_finish: nil}

  def fixture(:work_order_task) do
    {:ok, work_order_task} = Generic.create_work_order_task(@create_attrs)
    work_order_task
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all work_order_tasks", %{conn: conn} do
      conn = get(conn, Routes.work_order_task_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create work_order_task" do
    test "renders work_order_task when data is valid", %{conn: conn} do
      conn = post(conn, Routes.work_order_task_path(conn, :create), work_order_task: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.work_order_task_path(conn, :show, id))

      assert %{
               "id" => id,
               "completed_on" => "2010-04-17T14:00:00Z",
               "end_date" => "2010-04-17",
               "start_date" => "2010-04-17",
               "started_on" => "2010-04-17T14:00:00Z",
               "status" => "some status",
               "time_to_finish" => "2010-04-17T14:00:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.work_order_task_path(conn, :create), work_order_task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update work_order_task" do
    setup [:create_work_order_task]

    test "renders work_order_task when data is valid", %{conn: conn, work_order_task: %WorkOrderTask{id: id} = work_order_task} do
      conn = put(conn, Routes.work_order_task_path(conn, :update, work_order_task), work_order_task: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.work_order_task_path(conn, :show, id))

      assert %{
               "id" => id,
               "completed_on" => "2011-05-18T15:01:01Z",
               "end_date" => "2011-05-18",
               "start_date" => "2011-05-18",
               "started_on" => "2011-05-18T15:01:01Z",
               "status" => "some updated status",
               "time_to_finish" => "2011-05-18T15:01:01Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, work_order_task: work_order_task} do
      conn = put(conn, Routes.work_order_task_path(conn, :update, work_order_task), work_order_task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete work_order_task" do
    setup [:create_work_order_task]

    test "deletes chosen work_order_task", %{conn: conn, work_order_task: work_order_task} do
      conn = delete(conn, Routes.work_order_task_path(conn, :delete, work_order_task))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.work_order_task_path(conn, :show, work_order_task))
      end
    end
  end

  defp create_work_order_task(_) do
    work_order_task = fixture(:work_order_task)
    {:ok, work_order_task: work_order_task}
  end
end
