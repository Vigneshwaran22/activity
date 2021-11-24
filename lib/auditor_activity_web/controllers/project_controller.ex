defmodule AuditorActivityWeb.ProjectController do
  use AuditorActivityWeb, :controller

  alias AuditorActivity.Projects
  alias AuditorActivity.Generic.Project

  action_fallback AuditorActivityWeb.FallbackController

  # {
  #   @api {get} /api/projects Get Project List
  #   @apiVersion 0.0.1
  #   @apiName Get Project List
  #   @apiGroup Project

  #   @apiSuccess {List} data List of Projects.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 200 OK
  #     {
  #     "data": [
  #       {
  #           "name": "Demo's",
  #           "type": "Daily",
  #           "day_of_month1": "1",
  #           "day_of_month2": "23",
  #           "day_of_week": "Monday",
  #           "month1": "",
  #           "month2": "",
  #           "month3": "",
  #           "month4": "",
  #           "start_hour": "03:00:07",
  #           "end_hour": "23:00:07",
  #           "start_date": "2015-01-23",
  #           "end_date": "2015-01-28",
  #           "status": "Not Started",
  #           "started_on": "2015-01-23 21:20:07.123Z",
  #           "completed_on": "2015-01-23 21:20:07.123Z"
  #       }...
  #     }
  # }
  def index(conn, %{"offset" => offset, "limit" => limit, "sort" => sort, "order" => order, "search" => search}) do
    projects = Projects.list_projects(offset, limit, sort, order, search)
    render(conn, "index.json", projects: projects)
  end

  # {
  #   @api {post} /api/projects Add Project
  #   @apiVersion 0.0.1
  #   @apiName Add Project
  #   @apiGroup Project

  #   @apiParam (project) {String} name Project Name.
  #   @apiParam (project) {String} type Project Type.
  #   @apiParam (project) {Integer} day_of_month1 Month.
  #   @apiParam (project) {Integer} day_of_month2 Month.
  #   @apiParam (project) {String} day_of_week Weekday.
  #   @apiParam (project) {Time} start_hour Starting Time.
  #   @apiParam (project) {Time} end_hour Ending Time.
  #   @apiParam (project) {Integer} month1 Month.
  #   @apiParam (project) {Integer} month2 Month.
  #   @apiParam (project) {Integer} month3 Month.
  #   @apiParam (project) {Integer} month4 Month.
  #   @apiParam (project) {Time} start_date Starting Date.
  #   @apiParam (project) {Time} end_date Ending Date.
  #   @apiParam (project) {String} status Status.
  #   @apiParam {List} project Fields.

  #   @apiSuccess (Success 201) {List} data Added Project Details.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 201 OK
  #     {
  #       "data": {
  #           "name": "Demo",
  #           "type": "Daily",
  #           "day_of_month1": "1",
  #           "day_of_month2": "23",
  #           "day_of_week": "Monday",
  #           "month1": "",
  #           "month2": "",
  #           "month3": "",
  #           "month4": "",
  #           "start_hour": "03:00:07",
  #           "end_hour": "23:00:07",
  #           "start_date": "2015-01-23",
  #           "end_date": "2015-01-28",
  #           "status": "Not Started",
  #           "started_on": "2015-01-23 21:20:07.123Z",
  #           "completed_on": "2015-01-23 21:20:07.123Z"
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
  def create(conn, %{"project" => project_params}) do
    with {:ok, %Project{} = project} <- Projects.create_project(project_params) do
      send_resp(conn, 201, "")
      # conn
      # |> put_status(:created)
      # |> put_resp_header("location", Routes.project_path(conn, :show, project))
      # |> render("show.json", project: project)
    end
  end

  # {
  #   @api {get} /api/projects/project_id Get Project Information
  #   @apiVersion 0.0.1
  #   @apiName Get Project Information
  #   @apiGroup Project

  #   @apiParam {Number} project_id Project Unique ID.

  #   @apiSuccess {List} data Project Details.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 200 OK
  #     {
  #       "data": {
  #           "name": "Demo's",
  #           "type": "Daily",
  #           "day_of_month1": "1",
  #           "day_of_month2": "23",
  #           "day_of_week": "Monday",
  #           "month1": "",
  #           "month2": "",
  #           "month3": "",
  #           "month4": "",
  #           "start_hour": "03:00:07",
  #           "end_hour": "23:00:07",
  #           "start_date": "2015-01-23",
  #           "end_date": "2015-01-28",
  #           "status": "Not Started",
  #           "started_on": "2015-01-23 21:20:07.123Z",
  #           "completed_on": "2015-01-23 21:20:07.123Z"
  #       }
  #     }
  # }
  def show(conn, %{"id" => id}) do
    project = Projects.get_project!(id)
    render(conn, "show.json", project: project)
  end

  # {
  #   @api {put} /api/projects/project_id Update Project
  #   @apiVersion 0.0.1
  #   @apiName Update Project
  #   @apiGroup Project

  #   @apiParam (project) {String} name Project Name.
  #   @apiParam (project) {String} type Project Type.
  #   @apiParam (project) {Integer} day_of_month1 Month.
  #   @apiParam (project) {Integer} day_of_month2 Month.
  #   @apiParam (project) {String} day_of_week Weekday.
  #   @apiParam (project) {Time} start_hour Starting Time.
  #   @apiParam (project) {Time} end_hour Ending Time.
  #   @apiParam (project) {Integer} month1 Month.
  #   @apiParam (project) {Integer} month2 Month.
  #   @apiParam (project) {Integer} month3 Month.
  #   @apiParam (project) {Integer} month4 Month.
  #   @apiParam (project) {Time} start_date Starting Date.
  #   @apiParam (project) {Time} end_date Ending Date.
  #   @apiParam (project) {String} status Status.
  #   @apiParam {List} project Fields.

  #   @apiSuccess (Success 200) {List} data Updated project Details.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 200 OK
  #     {
  #       "data": {
  #           "name": "Demo's",
  #           "type": "Daily",
  #           "day_of_month1": "1",
  #           "day_of_month2": "23",
  #           "day_of_week": "Monday",
  #           "month1": "",
  #           "month2": "",
  #           "month3": "",
  #           "month4": "",
  #           "start_hour": "03:00:07",
  #           "end_hour": "23:00:07",
  #           "start_date": "2015-01-23",
  #           "end_date": "2015-01-28",
  #           "status": "Not Started",
  #           "started_on": "2015-01-23 21:20:07.123Z",
  #           "completed_on": "2015-01-23 21:20:07.123Z"
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
  def update(conn, %{"id" => id, "project" => project_params}) do
    project = Projects.get_project!(id)

    with {:ok, %Project{} = project} <- Projects.update_project(project, project_params) do
      render(conn, "show.json", project: project)
    end
  end

  # {
  #   @api {delete} /api/projects/project_id Delete Project
  #   @apiVersion 0.0.1
  #   @apiName Delete Project by ID
  #   @apiGroup Project

  #   @apiParam {Number} project_id Project Unique ID.

  #   @apiSuccess (Success 204) empty
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 204 OK
  #     ""
  # }
  def delete(conn, %{"id" => id}) do
    project = Projects.get_project!(id)

    with {:ok, _} <- Projects.delete_project(project) do
      send_resp(conn, :no_content, "")
    end
  end

  # {
  #   @api {post} /api/projects/project_id/status Update Status in Project
  #   @apiVersion 0.0.1
  #   @apiName Update Status in Project
  #   @apiGroup Project

  #   @apiParam {Number} project_id Project Unique ID.

  #   @apiParam (project) {String} status Status.
  #   @apiParam {List} project Fields.

  #   @apiSuccess (Success 201) {List} data Updated Project Details.
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
  def status_update(conn, %{"project_id" => id, "project" => project_params}) do
    project = Projects.get_project!(id)

    with {:ok, %Project{} = project} <- Projects.change_project_status(project, project_params) do
      render(conn, "show.json", project: project)
    end
  end
end
