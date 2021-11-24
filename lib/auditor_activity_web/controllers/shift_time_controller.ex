defmodule AuditorActivityWeb.ShiftTimeController do
  use AuditorActivityWeb, :controller

  alias AuditorActivity.Generic
  alias AuditorActivity.Generic.ShiftTime

  action_fallback AuditorActivityWeb.FallbackController

  def index(conn, %{"offset" => offset, "limit" => limit, "sort" => sort, "order" => order, "search" => search}) do
    shift_times = Generic.list_shift_times(offset, limit, sort, order, search)
    render(conn, "index.json", shift_times: shift_times)
  end

  def create(conn, %{"shift_time" => shift_time_params}) do
    with {:ok, %ShiftTime{} = shift_time} <- Generic.create_shift_time(shift_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.shift_time_path(conn, :show, shift_time))
      |> render("show.json", shift_time: shift_time)
    end
  end

  def show(conn, %{"id" => id}) do
    shift_time = Generic.get_shift_time!(id)
    render(conn, "show.json", shift_time: shift_time)
  end

  def update(conn, %{"id" => id, "shift_time" => shift_time_params}) do
    shift_time = Generic.get_shift_time!(id)

    with {:ok, %ShiftTime{} = shift_time} <- Generic.update_shift_time(shift_time, shift_time_params) do
      render(conn, "show.json", shift_time: shift_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    shift_time = Generic.get_shift_time!(id)

    with {:ok, %ShiftTime{}} <- Generic.delete_shift_time(shift_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
