defmodule AuditorActivityWeb.ProjectTypeController do
  use AuditorActivityWeb, :controller

  alias AuditorActivity.ProjectSettings
  alias AuditorActivity.Generic.ProjectType

  action_fallback AuditorActivityWeb.FallbackController

  # {
  #   @api {get} /api/projecttypes Get Project Type List
  #   @apiVersion 0.0.1
  #   @apiName Get Project Type List
  #   @apiGroup Project Type

  #   @apiSuccess {List} data List of Project Type.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 200 OK
  #     {
  #     "data": [
  #       {
  #           "description": "Demo Description",
  #           "id": 1,
  #           "name": "Demo Type",
  #           "tasks": [
  #             {
  #               "id": 1,
  #               "name": "Task"
  #             }
  #           ]
  #       }...
  #     }
  # }
  def index(conn, %{"offset" => offset, "limit" => limit, "sort" => sort, "order" => order, "search" => search}) do
    project_types = ProjectSettings.list_project_types(offset, limit, sort, order, search)
    render(conn, "index.json", project_types: project_types)
  end

  # {
  #   @api {post} /api/projecttypes Add Project Type
  #   @apiVersion 0.0.1
  #   @apiName Add Project Type
  #   @apiGroup Project Type

  #   @apiParam (project_type) {String} name Project Name.
  #   @apiParam (project_type) {String} description Project Description.
  #   @apiParam (project_type) {List} tasks Task Unique ID.
  #   @apiParam {List} project Fields.

  #   @apiSuccess (Success 201) {List} data Added Project Details.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 201 OK
  #     {
  #       "data": {
  #           "description": "Demo Description",
  #           "id": 1,
  #           "name": "Demo Type",
  #           "tasks": [
  #             {
  #               "id": 1,
  #               "name": "Task"
  #             }
  #           ]
  #       }
  #     }

  #   @apiError {List} errors fields.
  #   @apiErrorExample {json} Error-Response:
  #     HTTP/1.1 422 Not Found
  #     {
  #     "errors": {
  #         "description": [
  #           "can't be blank"
  #         ]
  #       }
  #     }
  # }
  def create(conn, %{"project_type" => project_type_params}) do
    IO.puts("projrct types works")
    with {:ok, %ProjectType{} = project_type} <- ProjectSettings.create_project_type(project_type_params) do
      IO.inspect project_type
      send_resp(conn, 201, "")
      # conn
      # |> put_status(:created)
      # |> put_resp_header("location", Routes.project_type_path(conn, :show, project_type))
      # |> render("show.json", project_type: project_type)
    end
  end

  # {
  #   @api {post} /api/projecttypes/projecttypes_id Get Project Type Information
  #   @apiVersion 0.0.1
  #   @apiName Get Project Type Information
  #   @apiGroup Project Type

  #   @apiParam {Number} projecttypes_id Project Type Unique ID.

  #   @apiSuccess {List} data Project Details.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 200 OK
  #     {
  #       "data": {
  #           "description": "Demo Description",
  #           "id": 1,
  #           "name": "Demo Type",
  #           "tasks": [
  #             {
  #               "id": 1,
  #               "name": "Task"
  #             }
  #           ]
  #       }
  #     }
  # }
  def show(conn, %{"id" => id}) do
    project_type = ProjectSettings.get_project_type!(id)
    render(conn, "show.json", project_type: project_type)
  end

  # {
  #   @api {put} /api/projecttypes/projecttypes_id Update Project Type
  #   @apiVersion 0.0.1
  #   @apiName Update Project Type
  #   @apiGroup Project Type

  #   @apiParam {Number} projecttypes_id Project Type Unique ID.

  #   @apiParam (project_type) {String} name Project Name.
  #   @apiParam (project_type) {String} description Project Description.
  #   @apiParam (project_type) {List} tasks Task Unique ID.
  #   @apiParam {List} project Fields.

  #   @apiSuccess (Success 201) {List} data Added Project Details.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 201 OK
  #     {
  #       "data": {
  #           "description": "Demo Description",
  #           "id": 1,
  #           "name": "Demo Type",
  #           "tasks": [
  #             {
  #               "id": 1,
  #               "name": "Task"
  #             }
  #           ]
  #       }
  #     }

  #   @apiError {List} errors fields.
  #   @apiErrorExample {json} Error-Response:
  #     HTTP/1.1 422 Not Found
  #     {
  #     "errors": {
  #         "description": [
  #           "can't be blank"
  #         ]
  #       }
  #     }
  # }
  def update(conn, %{"id" => id, "project_type" => project_type_params}) do
    project_type = ProjectSettings.get_project_type!(id)

    with {:ok, %ProjectType{} = project_type} <- ProjectSettings.update_project_type(project_type, project_type_params) do
      render(conn, "show.json", project_type: project_type)
    end
  end

  # {
  #   @api {delete} /api/projecttypes/projecttypes_id Delete Project Type
  #   @apiVersion 0.0.1
  #   @apiName Delete Project Type List
  #   @apiGroup Project Type

  #   @apiParam {Number} projecttypes_id Project Type Unique ID.

  #   @apiSuccess {List} data List of Project Type.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 204 OK
  #     ""
  # }
  def delete(conn, %{"id" => id}) do
    project_type = ProjectSettings.get_project_type!(id)

    with {:ok, %ProjectType{}} <- ProjectSettings.delete_project_type(project_type) do
      send_resp(conn, :no_content, "")
    end
  end
end
