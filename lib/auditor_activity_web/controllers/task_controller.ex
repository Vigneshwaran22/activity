defmodule AuditorActivityWeb.TaskController do
  use AuditorActivityWeb, :controller

  alias AuditorActivity.TaskSettings
  alias AuditorActivity.Generic.Task

  action_fallback AuditorActivityWeb.FallbackController

  # {
  #   @api {get} /api/tasks Get Tasks
  #   @apiVersion 0.0.1
  #   @apiName Get Task List
  #   @apiGroup Task

  #   @apiSuccess {List} data List of Tasks.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 200 OK
  #     {
  #     "data": [
  #       {
  #           "completed_on": null,
  #           "description": "Description",
  #           "end_date": "2015-01-28",
  #           "id": 4,
  #           "name": "Task",
  #           "project_types": [
  #             {
  #               "id": 1,
  #               "name": "Demo ProjectType"
  #             }
  #           ],
  #           "start_date": "2015-01-23",
  #           "started_on": null,
  #           "status": "Not Started",
  #           "time_to_finish": "2015-01-23T21:20:07Z"
  #       }...
  #     }
  # }
  def index(conn, %{"offset" => offset, "limit" => limit, "sort" => sort, "order" => order, "search" => search}) do
    tasks = TaskSettings.list_tasks(offset, limit, sort, order, search)
    render(conn, "index.json", tasks: tasks)
  end

  # {
  #   @api {post} /api/tasks Add Task
  #   @apiVersion 0.0.1
  #   @apiName Add Task
  #   @apiGroup Task

  #   @apiParam (task) {String} name Task Name.
  #   @apiParam (task) {String} description Task Description.
  #   @apiParam (task) {String} status Task Status.
  #   @apiParam (task) {DateTime} time_to_finish Month.
  #   @apiParam (task) {Date} start_date Start Date.
  #   @apiParam (task) {Date} end_date End Date.
  #   @apiParam (task) {integer} project_id Project Unique ID.
  #   @apiParam (task) {List} project_types Fields.
  #   @apiParam (project_types) {integer} project_types_id Project Type Unique ID.
  #   @apiParam {List} task Fields.

  #   @apiSuccess (Success 201) {List} data Added Task Details.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 201 OK
  #     {
  #       "data": {
  #           "description": "Description",
  #           "id": 1,
  #           "name": "Task's",
  #           "project_type_id": null,
  #           "status": "Started",
  #           "time_to_finish": "2015-01-23T21:20:07Z"
  #       }
  #     }

  #   @apiError {List} errors fields.
  #   @apiErrorExample {json} Error-Response:
  #     HTTP/1.1 422 Not Found
  #     {
  #     "errors": {
  #         "type": [
  #           "can't be blank"
  #         ]
  #       }
  #     }
  # }
  def create(conn, %{"task" => task_params}) do
    with {:ok, %Task{} = task} <- TaskSettings.create_task(task_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.task_path(conn, :show, task))
      |> render("show.json", task: task)
      # send_resp(conn, 201, "")
    end
  end

  # {
  #   @api {get} /api/tasks/task_id Get Task Information
  #   @apiVersion 0.0.1
  #   @apiName Get Task Information
  #   @apiGroup Task

  #   @apiParam {Number} task_id Task Unique ID.

  #   @apiSuccess {List} data Task Details.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 200 OK
  #     {
  #       "data": {
  #           "completed_on": null,
  #           "description": "Description",
  #           "end_date": "2015-01-28",
  #           "id": 4,
  #           "name": "Task",
  #           "project_types": [
  #             {
  #               "id": 1,
  #               "name": "Demo ProjectType"
  #             }
  #           ],
  #           "start_date": "2015-01-23",
  #           "started_on": null,
  #           "status": "Not Started",
  #           "time_to_finish": "2015-01-23T21:20:07Z"
  #       }
  #     }
  # }
  def show(conn, %{"id" => id}) do
    task = TaskSettings.get_task!(id)
    render(conn, "show.json", task: task)
  end

  # {
  #   @api {put} /api/task/task_id Update Task
  #   @apiVersion 0.0.1
  #   @apiName Update Task
  #   @apiGroup Task

  #   @apiParam {Number} task_id Task Unique ID.

  #   @apiParam (task) {String} name Task Name.
  #   @apiParam (task) {String} description Task Description.
  #   @apiParam (task) {String} status Task Status.
  #   @apiParam (task) {DateTime} time_to_finish Month.
  #   @apiParam (task) {Date} start_date Start Date.
  #   @apiParam (task) {Date} end_date End Date.
  #   @apiParam (task) {integer} project_id Project Unique ID.
  #   @apiParam (task) {List} project_types Fields.
  #   @apiParam (project_types) {integer} project_types_id Project Type Unique ID.
  #   @apiParam {List} task Fields.

  #   @apiSuccess (Success 200) {List} data Updated project Details.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 200 OK
  #     {
  #       "data": {
  #           "completed_on": null,
  #           "description": "Description",
  #           "end_date": "2015-01-28",
  #           "id": 4,
  #           "name": "Task",
  #           "project_types": [
  #             {
  #               "id": 1,
  #               "name": "Demo ProjectType"
  #             }
  #           ],
  #           "start_date": "2015-01-23",
  #           "started_on": null,
  #           "status": "Not Started",
  #           "time_to_finish": "2015-01-23T21:20:07Z"
  #       }
  #     }

  #   @apiError {List} errors fields.
  #   @apiErrorExample {json} Error-Response:
  #     HTTP/1.1 422 Not Found
  #     {
  #     "errors": {
  #         "type": [
  #           "can't be blank"
  #         ]
  #       }
  #     }
  # }
  def update(conn, %{"id" => id, "task" => task_params}) do
    task = TaskSettings.get_task!(id)

    with {:ok, %Task{} = task} <- TaskSettings.update_task(task, task_params) do
      render(conn, "show.json", task: task)
    end
  end

  # {
  #   @api {delete} /api/tasks/task_id Delete Task
  #   @apiVersion 0.0.1
  #   @apiName Delete Task by ID
  #   @apiGroup Task

  #   @apiParam {Number} task_id Task Unique ID.

  #   @apiSuccess (Success 204) empty
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 204 OK
  #     ""
  # }
  def delete(conn, %{"id" => id}) do
    task = TaskSettings.get_task!(id)

    with {:ok, %Task{}} <- TaskSettings.delete_task(task) do
      send_resp(conn, :no_content, "")
    end
  end

  # {
  #   @api {post} /api/tasks/task_id/status Update Status in Task
  #   @apiVersion 0.0.1
  #   @apiName Update Status in Task
  #   @apiGroup Task

  #   @apiParam {Number} task_id Task Unique ID.

  #   @apiParam (task) {String} status Status.
  #   @apiParam {List} task Fields.

  #   @apiSuccess (Success 201) {List} data Updated Task Details.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 201 OK
  #     {
  #       "data": {
  #           "status": "Completed"
  #       }
  #     }

  #   @apiError {List} errors fields.
  #   @apiErrorExample {json} Error-Response:
  #     HTTP/1.1 422 Not Found
  #     {
  #     "errors": {
  #         "status": [
  #           "can't be blank"
  #         ]
  #       }
  #     }
  # }
  def status_update(conn, %{"task_id" => id, "task" => task_params}) do
    task = TaskSettings.get_task!(id)

    with {:ok, %Task{} = task} <- TaskSettings.change_task_status(task, task_params) do
      render(conn, "show.json", task: task)
    end
  end
end
