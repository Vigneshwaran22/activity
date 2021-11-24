defmodule AuditorActivity.NextWorkOrder do
  alias AuditorActivity.Projects

  def get_list() do
    Projects.list_projects() |> Enum.map(fn x -> next_work_order(x.schedule_type, x) end)
  end

  def next_work_order("Fortnight", params) do
    start_date = params.start_date
    start_hour = params.start_hour
    day_select = params.day_of_week
    day_of_week = Date.day_of_week(start_date)
    IO.inspect day_select
    IO.inspect day_of_week
    diff_from_today = day_select - day_of_week
    two_weeks = 14 - day_of_week + day_select
    three_weeks = 21 - day_of_week + day_select
    six_weeks = 42 - day_of_week + day_select
    this_week = start_date |> Date.add(diff_from_today)
    diff_date = 7 - day_of_week + day_select
    date = create_date_time(this_week, start_hour)
    case params.fortnite do
      1 -> 
        next_week = start_date |> Date.add(two_weeks)
        next_date = create_date_time(next_week, start_hour)
        compare_date_time(date, next_date)
      2 -> 
        next_week = start_date |> Date.add(three_weeks)
        next_date = create_date_time(next_week, start_hour)
        compare_date_time(date, next_date)
      3-> 
        next_week = start_date |> Date.add(six_weeks)
        next_date = create_date_time(next_week, start_hour)
        compare_date_time(date, next_date)
      _ -> 
        next_week = start_date |> Date.add(diff_date)
        next_date = create_date_time(next_week, start_hour)
        compare_date_time(date, next_date)
    end
  end

  def next_work_order("Weekly", params) do
    start_date = params.start_date
    start_hour = params.start_hour
    day_select = params.day_of_week
    day_of_week = Date.day_of_week(start_date)
    diff_from_today = day_select - day_of_week
    diff_date = 7 - day_of_week + day_select
    this_week = start_date |> Date.add(diff_from_today)
    next_week = start_date |> Date.add(diff_date)
    date = create_date_time(this_week, start_hour)
    next_date = create_date_time(next_week, start_hour)
    compare_date_time(date, next_date)
  end

  def next_work_order("Annually", params) do
    start_date = params.start_date
    start_hour = params.start_hour
    day_of_month = params.day_of_month
    month = params.month
    select_date = create_date(start_date.year, month, day_of_month)
    date = create_date_time(select_date, start_hour)
    next_year_date = create_date(start_date.year + 1, month, day_of_month)
    next_date = create_date_time(next_year_date, start_hour)
    compare_date_time(date, next_date)
  end

  def next_work_order("Half yearly", params) do
    start_date = params.start_date
    start_hour = params.start_hour
    day_of_month = params.day_of_month
    month = params.month
    month2 = month + 6

    months_list =
      [month, month2]
      |> Enum.sort()
      |> Enum.split_while(fn x -> x < start_date.month end)
    IO.inspect months_list
    months = elem(months_list, 1) ++ elem(months_list, 0)
    first_month = Enum.at(months, 0)
    secound_month = Enum.at(months, 1)
    select_date = create_date(start_date.year, first_month, day_of_month)
    date = create_date_time(select_date, start_hour)
    next_month_date = create_date(start_date.year, secound_month, day_of_month)
    next_date = create_date_time(next_month_date, start_hour)
    compare_date_time(date, next_date)
  end

  def next_work_order("Quarterly", params) do
    start_date = params.start_date
    start_hour = params.start_hour
    day_of_month = params.day_of_month
    month = params.month
    month2 = month + 3
    month3 = month + 6
    month4 = month + 9

    months_list =
      [month, month2, month3, month4]
      |> Enum.sort()
      |> Enum.split_while(fn x -> x < start_date.month end)

    months = elem(months_list, 1) ++ elem(months_list, 0)
    first_month = Enum.at(months, 0)
    secound_month = Enum.at(months, 1)
    select_date = create_date(start_date.year, first_month, day_of_month)
    date = create_date_time(select_date, start_hour)
    next_month_date = create_date(start_date.year, secound_month, day_of_month)
    next_date = create_date_time(next_month_date, start_hour)
    compare_date_time(date, next_date)
  end

  def next_work_order("Monthly", params) do
    start_date = params.start_date
    start_hour = params.start_hour
    day_of_month = params.day_of_month
    select_date = create_date(start_date.year, start_date.month, day_of_month)
    date = create_date_time(select_date, start_hour)
    next_month_date = create_date(start_date.year, start_date.month + 1, day_of_month)
    next_date = create_date_time(next_month_date, start_hour)
    compare_date_time(date, next_date)
  end

  def next_work_order("Daily", params) do
    start_hour = params.start_hour
    tomorrow = Date.utc_today() |> Date.add(1)
    date = create_date_time(Date.utc_today(), start_hour)
    next_date = create_date_time(tomorrow, start_hour)
    compare_date_time(date, next_date)
  end

  def compare_date_time(date, next_date) do
    IO.inspect date
    IO.inspect next_date
    current_date_time = NaiveDateTime.utc_now()
    diff = NaiveDateTime.diff(current_date_time, date)

    if diff < 0 do
      {date, next_date}
      # next_work_order_on(date)
    else
      {date, next_date}
      # next_work_order_on(next_date)
    end
  end

  def next_work_order_on(date_time) do
    IO.inspect(date_time)
  end

  def create_date_time(date, time) do
    NaiveDateTime.new(date, time) |> elem(1)
  end

  def create_date(year, month, day) do
    date = Date.new(year, month, day)
    case date |> elem(0) do
      :ok -> 
        Date.new(year, month, day) |> elem(1)
      _ -> create_date(year, month, day - 1)
    end
  end
end
