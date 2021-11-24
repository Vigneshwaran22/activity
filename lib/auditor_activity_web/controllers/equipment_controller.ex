defmodule AuditorActivityWeb.EquipmentController do
  use AuditorActivityWeb, :controller

  alias AuditorActivity.EquipmentSettings
  alias AuditorActivity.Generic.Equipment

  action_fallback AuditorActivityWeb.FallbackController

  # {
  #   @api {get} /api/equipments Get Equipments
  #   @apiVersion 0.0.1
  #   @apiName Get Equipments
  #   @apiGroup Equipment

  #   @apiSuccess {List} data List of Equipments.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 200 OK
  #     {
  #     "data": [
  #       {
  #           "brand_name": "Voltos",
  #           "id": 2,
  #           "serial_no": "123456G678",
  #           "variant": "Genset 1"
  #        }...
  #      ]
  #     }
  # }
  def index(conn, %{"offset" => offset, "limit" => limit, "sort" => sort, "order" => order, "search" => search}) do
    equipments = EquipmentSettings.list_equipments(offset, limit, sort, order, search)
    render(conn, "index.json", equipments: equipments)
  end

  # {
  #   @api {post} /api/equipments Add Equipments
  #   @apiVersion 0.0.1
  #   @apiName Add Equipment
  #   @apiGroup Equipment

  #   @apiParam (equipment) {String} brand_name Equipment Name.
  #   @apiParam (equipment) {String} serial_no Serial Number.
  #   @apiParam (equipment) {String} variant Variant.
  #   @apiParam {List} equipment Fields.

  #   @apiSuccess (Success 201) {List} data Added Checklist Details.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 201 OK
  #     {
  #       "data": {
  #           "brand_name": "Voltos",
  #           "id": 2,
  #           "serial_no": "123456G678",
  #           "variant": "Genset 1"
  #       }
  #     }

  #   @apiError {List} errors fields.
  #   @apiErrorExample {json} Error-Response:
  #     HTTP/1.1 422 Not Found
  #     {
  #     "errors": {
  #         "serial_no": [
  #           "can't be blank"
  #         ]
  #       }
  #     }
  # }
  def create(conn, %{"equipment" => equipment_params}) do
    with {:ok, %Equipment{} = equipment} <- EquipmentSettings.create_equipment(equipment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.equipment_path(conn, :show, equipment))
      |> render("show.json", equipment: equipment)
    end
  end

  # {
  #   @api {get} /api/equipments/equipments_id Get Equipment Information
  #   @apiVersion 0.0.1
  #   @apiName Get Equipment Information
  #   @apiGroup Equipment

  #   @apiParam {Number} equipments_id Equipment Unique ID.

  #   @apiSuccess {List} data Equipment Details.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 200 OK
  #     {
  #       "data": {
  #           "brand_name": "Voltos",
  #           "id": 2,
  #           "serial_no": "123456G678",
  #           "variant": "Genset 1"
  #             }
  #           ]
  #       }
  #     }
  # }
  def show(conn, %{"id" => id}) do
    equipment = EquipmentSettings.get_equipment!(id)
    render(conn, "show.json", equipment: equipment)
  end

  # {
  #   @api {put} /api/equipments/equipments_id Update Equipments
  #   @apiVersion 0.0.1
  #   @apiName Update Equipment
  #   @apiGroup Equipment

  #   @apiParam {Number} equipments_id Equipment Unique ID.

  #   @apiParam (equipment) {String} brand_name Equipment Name.
  #   @apiParam (equipment) {String} serial_no Serial Number.
  #   @apiParam (equipment) {String} variant Variant.
  #   @apiParam {List} equipment Fields.

  #   @apiSuccess (Success 201) {List} data Added Checklist Details.
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 201 OK
  #     {
  #       "data": {
  #           "brand_name": "Voltos",
  #           "id": 2,
  #           "serial_no": "123456G678",
  #           "variant": "Genset 1"
  #       }
  #     }

  #   @apiError {List} errors fields.
  #   @apiErrorExample {json} Error-Response:
  #     HTTP/1.1 422 Not Found
  #     {
  #     "errors": {
  #         "serial_no": [
  #           "can't be blank"
  #         ]
  #       }
  #     }
  # }
  def update(conn, %{"id" => id, "equipment" => equipment_params}) do
    equipment = EquipmentSettings.get_equipment!(id)

    with {:ok, %Equipment{} = equipment} <- EquipmentSettings.update_equipment(equipment, equipment_params) do
      render(conn, "show.json", equipment: equipment)
    end
  end

  # {
  #   @api {delete} /api/equipments/equipments_id Delete Equipment
  #   @apiVersion 0.0.1
  #   @apiName Delete Equipment by ID
  #   @apiGroup Equipment

  #   @apiParam {Number} equipments_id Equipment Unique ID.

  #   @apiSuccess (Success 204) empty
  #   @apiSuccessExample {json} Success-Response:
  #     HTTP/1.1 204 OK
  #     ""
  # }
  def delete(conn, %{"id" => id}) do
    equipment = EquipmentSettings.get_equipment!(id)

    with {:ok, %Equipment{}} <- EquipmentSettings.delete_equipment(equipment) do
      send_resp(conn, :no_content, "")
    end
  end
end
