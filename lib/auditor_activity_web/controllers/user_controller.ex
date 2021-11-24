defmodule AuditorActivityWeb.UserController do
  use AuditorActivityWeb, :controller

  alias AuditorActivity.UserSettings
  alias AuditorActivity.Generic.User

  action_fallback AuditorActivityWeb.FallbackController

  # {
  #   @api {get} /api/users Get Users
  #   @apiVersion 0.0.1
  #   @apiName Get Users List
  #   @apiGroup User

  #   @apiSuccess {List} data List of Users.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 200 OK
  #     {
  #     "data": [
  #       {
  #           "active_status": true,
  #           "email": "dhanush623@gmail.com",
  #           "first_name": "Dhanush",
  #           "id": 1,
  #           "last_name": "Raja"
  #       }...
  #     }
  # }
  def index(conn, %{"offset" => offset, "limit" => limit, "sort" => sort, "order" => order, "search" => search}) do
    users = UserSettings.list_users(offset, limit, sort, order, search)
    render(conn, "index.json", users: users)
  end

  # {
  #   @api {post} /api/users Add User
  #   @apiVersion 0.0.1
  #   @apiName Add User
  #   @apiGroup User

  #   @apiParam (user) {String} email User Name.
  #   @apiParam (user) {String} first_name First Name.
  #   @apiParam (user) {String} last_name Last Name.
  #   @apiParam (user) {Boolean} active_status Active Status.
  #   @apiParam (user) {List} tasks Fields.
  #   @apiParam (tasks) {Integer} task_id Task Unique ID.
  #   @apiParam (user) {List} projects Fields.
  #   @apiParam (projects) {Integer} project_id Project Unique ID.
  #   @apiParam {List} user Fields.

  #   @apiSuccess (Success 201) {List} data Added Task Details.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 201 OK
  #     {
  #       "data": {
  #           "active_status": true,
  #           "email": "dhanush623@gmail.com",
  #           "first_name": "Dhanush",
  #           "id": 1,
  #           "last_name": "Raja"
  #       }
  #     }

  #   @apiError {List} errors fields.
  #   @apiErrorExample {json} Error-Response:
  #     HTTP/1.1 422 Not Found
  #     {
  #     "errors": {
  #         "email": [
  #           "can't be blank"
  #         ]
  #       }
  #     }
  # }
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- UserSettings.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  # {
  #   @api {get} /api/users/user_id Get User Information
  #   @apiVersion 0.0.1
  #   @apiName Get Users Information
  #   @apiGroup User

  #   @apiParam {Number} user_id User Unique ID.

  #   @apiSuccess {List} data List of Users.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 200 OK
  #     {
  #     "data": [
  #           "active_status": true,
  #           "email": "dhanush623@gmail.com",
  #           "first_name": "Dhanush",
  #           "id": 1,
  #           "last_name": "Raja"
  #     }
  # }
  def show(conn, %{"id" => id}) do
    user = UserSettings.get_user!(id)
    render(conn, "show.json", user: user)
  end

  # {
  #   @api {post} /api/users/user_id Update User
  #   @apiVersion 0.0.1
  #   @apiName Update User
  #   @apiGroup User

  #   @apiParam {Number} user_id User Unique ID.

  #   @apiParam (user) {String} email User Name.
  #   @apiParam (user) {String} first_name First Name.
  #   @apiParam (user) {String} last_name Last Name.
  #   @apiParam (user) {Boolean} active_status Active Status.
  #   @apiParam (user) {List} tasks Fields.
  #   @apiParam (tasks) {Integer} task_id Task Unique ID.
  #   @apiParam (user) {List} projects Fields.
  #   @apiParam (projects) {Integer} project_id Project Unique ID.
  #   @apiParam {List} user Fields.

  #   @apiSuccess (Success 201) {List} data Added Task Details.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 201 OK
  #     {
  #       "data": {
  #           "active_status": true,
  #           "email": "dhanush623@gmail.com",
  #           "first_name": "Dhanush",
  #           "id": 1,
  #           "last_name": "Raja"
  #       }
  #     }

  #   @apiError {List} errors fields.
  #   @apiErrorExample {json} Error-Response:
  #     HTTP/1.1 422 Not Found
  #     {
  #     "errors": {
  #         "email": [
  #           "can't be blank"
  #         ]
  #       }
  #     }
  # }
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserSettings.get_user!(id)

    with {:ok, %User{} = user} <- UserSettings.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  # {
  #   @api {delete} /api/users/users_id Delete User
  #   @apiVersion 0.0.1
  #   @apiName Delete User by ID
  #   @apiGroup User

  #   @apiParam {Number} users_id User Unique ID.

  #   @apiSuccess (Success 204) empty
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 204 OK
  #     ""
  # }
  def delete(conn, %{"id" => id}) do
    user = UserSettings.get_user!(id)

    with {:ok, %User{}} <- UserSettings.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def activate(conn, %{"id" => id}) do
    user = UserSettings.get_user!(id)

    with {:ok, %User{} = user} <- UserSettings.activate_user(user) do
      render(conn, "show.json", user: user)
    end
  end

  def deactivate(conn, %{"id" => id}) do
    user = UserSettings.get_user!(id)

    with {:ok, %User{} = user} <- UserSettings.deactivate_user(user) do
      render(conn, "show.json", user: user)
    end
  end
end
