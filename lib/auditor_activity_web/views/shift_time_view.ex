defmodule AuditorActivityWeb.ShiftTimeView do
  use AuditorActivityWeb, :view
  alias AuditorActivityWeb.ShiftTimeView

  def render("index.json", %{shift_times: shift_times}) do
    %{
      shift_times:
        render_many(
          shift_times.entries,
          ShiftTimeView,
          "shift_time.json"
        ),
      page_number: shift_times.page_number,
      page_size: shift_times.page_size,
      total_entries: shift_times.total_entries,
      total_pages: shift_times.total_pages
    }
    # %{data: render_many(shift_times, ShiftTimeView, "shift_time.json")}
  end

  def render("show.json", %{shift_time: shift_time}) do
    %{data: render_one(shift_time, ShiftTimeView, "shift_time.json")}
  end

  def render("shift_time.json", %{shift_time: shift_time}) do
    %{id: shift_time.id,
       name: shift_time.name,
      start_time: shift_time.start_time,
      end_time: shift_time.end_time}
  end

  def render("shift_times.json", %{shift_time: shift_time}) do
    %{data: render_one(shift_time, ShiftTimeView, "shift_time.json")}
  end
end
