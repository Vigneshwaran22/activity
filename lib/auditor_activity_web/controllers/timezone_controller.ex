defmodule AuditorActivityWeb.TimezoneController do
  use AuditorActivityWeb, :controller

  alias AuditorActivity.TimezoneSetting
  alias AuditorActivity.Generic.Timezone

  action_fallback AuditorActivityWeb.FallbackController

  def index(conn, _params) do
    timezones = TimezoneSetting.list_timezones()
    render(conn, "index.json", timezones: timezones)
  end

  def create(conn, %{"timezone" => timezone_params}) do
    with {:ok, %Timezone{} = timezone} <- TimezoneSetting.create_timezone(timezone_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.timezone_path(conn, :show, timezone))
      |> render("show.json", timezone: timezone)
    end
  end

  def show(conn, %{"id" => id}) do
    timezone = TimezoneSetting.get_timezone!(id)
    render(conn, "show.json", timezone: timezone)
  end

  def update(conn, %{"id" => id, "timezone" => timezone_params}) do
    timezone = TimezoneSetting.get_timezone!(id)

    with {:ok, %Timezone{} = timezone} <- TimezoneSetting.update_timezone(timezone, timezone_params) do
      render(conn, "show.json", timezone: timezone)
    end
  end

  def delete(conn, %{"id" => id}) do
    timezone = TimezoneSetting.get_timezone!(id)

    with {:ok, %Timezone{}} <- TimezoneSetting.delete_timezone(timezone) do
      send_resp(conn, :no_content, "")
    end
  end
end
