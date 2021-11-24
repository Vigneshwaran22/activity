defmodule AuditorActivityWeb.TimezoneView do
  use AuditorActivityWeb, :view
  alias AuditorActivityWeb.TimezoneView

  def render("index.json", %{timezones: timezones}) do
    %{data: render_many(timezones, TimezoneView, "timezone.json")}
  end

  def render("show.json", %{timezone: timezone}) do
    %{data: render_one(timezone, TimezoneView, "timezone.json")}
  end

  def render("timezone.json", %{timezone: timezone}) do
    %{id: timezone.id,
       city: timezone.city,
      city_low: timezone.city_low,
      city_stripped: timezone.city_stripped,
      continent: timezone.continent,
      label: timezone.label,
      offset: timezone.offset,
      state: timezone.state,
      utc_offset_seconds: timezone.utc_offset_seconds}
  end
end
