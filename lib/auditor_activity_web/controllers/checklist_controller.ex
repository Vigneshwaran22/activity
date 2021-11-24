defmodule AuditorActivityWeb.ChecklistController do
  use AuditorActivityWeb, :controller

  alias AuditorActivity.TaskSettings
  alias AuditorActivity.Generic.Checklist

  action_fallback AuditorActivityWeb.FallbackController

  # {
  #   @api {get} /api/checklists Get Check List
  #   @apiVersion 0.0.1
  #   @apiName Get Check List
  #   @apiGroup Check List

  #   @apiSuccess {List} data List of Check List.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 200 OK
  #     {
  #     "data": [
  #       {
  #           "description": "Demo Description",
  #           "id": 2,
  #           "name": "Demo",
  #           "checkpoints": [
  #             {
  #               "id": 1,
  #               "name": "Check Point1"
  #             },
  #             {
  #               "id": 2,
  #               "name": "Check Point2"
  #             }
  #           ]
  #       }...
  #     }
  # }
  def index(conn, %{"offset" => offset, "limit" => limit, "sort" => sort, "order" => order, "search" => search}) do
    checklists = TaskSettings.list_checklists(offset, limit, sort, order, search)
    render(conn, "index.json", checklists: checklists)
  end

  # {
  #   @api {post} /api/checklists Add Check List
  #   @apiVersion 0.0.1
  #   @apiName Add Check List
  #   @apiGroup Check List

  #   @apiParam (checklist) {String} name Check List Name.
  #   @apiParam (checklist) {String} description Check List Description.
  #   @apiParam (checklist) {List} checkpoints Fields.
  #   @apiParam (checkpoints) {String} name Check Point Name.
  #   @apiParam {List} checklist Fields.

  #   @apiSuccess (Success 201) {List} data Added Checklist Details.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 201 OK
  #     {
  #       "data": {
  #           "description": "Demo Description",
  #           "id": 1,
  #           "name": "Demo",
  #           "checkpoints": [
  #             {
  #               "name": "Check Point1"
  #             },{
  #               "name": "Check Point2"
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
  def create(conn, %{"checklist" => checklist_params}) do
    with {:ok, %Checklist{} = checklist} <- TaskSettings.create_checklist(checklist_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.checklist_path(conn, :show, checklist))
      |> render("show.json", checklist: checklist)
    end
  end

  # {
  #   @api {get} /api/checklists/checklists_id Get Checklist Information
  #   @apiVersion 0.0.1
  #   @apiName Get Checklists Information
  #   @apiGroup Check List

  #   @apiParam {Number} checklists_id Check List Unique ID.

  #   @apiSuccess {List} data Check List Details.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 200 OK
  #     {
  #       "data": {
  #           "description": "Demo Description",
  #           "id": 2,
  #           "name": "Demo",
  #           "checkpoints": [
  #             {
  #               "id": 1,
  #               "name": "Check Point1"
  #             },
  #             {
  #               "id": 2,
  #               "name": "Check Point2"
  #             }
  #           ]
  #       }
  #     }
  # }
  def show(conn, %{"id" => id}) do
    checklist = TaskSettings.get_checklist!(id)
    render(conn, "show.json", checklist: checklist)
  end

  # {
  #   @api {put} /api/checklists/checklists_id Update Project
  #   @apiVersion 0.0.1
  #   @apiName Update Check List
  #   @apiGroup Check List

  #   @apiParam {Number} checklists_id Check List Unique ID.

  #   @apiParam (checklist) {String} name Check List Name.
  #   @apiParam (checklist) {String} description Check List Description.
  #   @apiParam (checklist) {List} checkpoints Fields.
  #   @apiParam (checkpoints) {String} name Check Point Name.
  #   @apiParam {List} checklist Fields.

  #   @apiSuccess (Success 201) {List} data Added Checklist Details.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 201 OK
  #     {
  #       "data": {
  #           "description": "Demo Description",
  #           "id": 1,
  #           "name": "Demo's",
  #           "checkpoints": [
  #             {
  #               "id": 1,
  #               "name": "Check Point1"
  #             },
  #             {
  #               "id": 2,
  #               "name": "Check Point2"
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
  def update(conn, %{"id" => id, "checklist" => checklist_params}) do
    checklist = TaskSettings.get_checklist!(id)

    with {:ok, %Checklist{} = checklist} <- TaskSettings.update_checklist(checklist, checklist_params) do
      render(conn, "show.json", checklist: checklist)
    end
  end

  # {
  #   @api {delete} /api/checklists/checklists_id Delete Check List
  #   @apiVersion 0.0.1
  #   @apiName Delete Check List by ID
  #   @apiGroup Check List

  #   @apiParam {Number} checklists_id Check List Unique ID.

  #   @apiSuccess (Success 204) empty
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 204 OK
  #     ""
  # }
  def delete(conn, %{"id" => id}) do
    checklist = TaskSettings.get_checklist!(id)
    with {:ok, %Checklist{}} <- TaskSettings.delete_checklist(checklist) do
      send_resp(conn, :no_content, "")
    end
  end
end
