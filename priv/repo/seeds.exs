# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     AuditorActivity.Repo.insert!(%AuditorActivity.SomeSchema%{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# alias AuditorActivity.Projects
# alias AuditorActivity.NextWorkOrder
alias AuditorActivity.Repo
import Ecto.Query, warn: false
alias AuditorActivity.Generic.{Checklist, User, ProjectType, Equipment, EquipmentCategory, Task}
alias AuditorActivity.{UserSettings, TaskSettings, ProjectSettings, EquipmentSettings, Projects, TimezoneSetting}

# File.stream!("assets/test_next_work_order.csv")
# |> CSV.decode()
# |> Enum.each(fn
#   {:ok,
#    [
#      name,
#      type,
#      schedule_type,
#      day_of_month,
#      day_of_week,
#      month,
#      fortnite,
#      month2,
#      month3,
#      month4,
#      start_hour,
#      end_hour,
#      start_date,
#      end_date,
#      status,
#      _expected_results,
#      _actual_results
#    ]} ->
#     if name != "name" do
#       wo = %{
#         name: name,
#         type: type,
#         schedule_type: schedule_type,
#         day_of_month: Integer.parse(day_of_month) |> elem(0),
#         day_of_week: Integer.parse(day_of_week) |> elem(0),
#         fortnite: Integer.parse(fortnite) |> elem(0),
#         month: Integer.parse(month) |> elem(0),
#         month2: Integer.parse(month2) |> elem(0),
#         month3: Integer.parse(month3) |> elem(0),
#         month4: Integer.parse(month4) |> elem(0),
#         start_hour: Time.from_iso8601(start_hour) |> elem(1),
#         end_hour: Time.from_iso8601(end_hour) |> elem(1),
#         start_date: Date.from_iso8601(start_date) |> elem(1),
#         end_date: Date.from_iso8601(end_date) |> elem(1),
#         status: status
#       }

#       NextWorkOrder.next_work_order(wo.schedule_type, wo) |> IO.inspect()
#     end

#   {:error, message} ->
#     IO.inspect(message)
# end)

File.stream!("assets/user.csv")
|> CSV.decode()
|> Enum.each(fn
  {:ok,
   [
     first_name,
     last_name,
     email
   ]} ->
    if email != "email" do
      wo = %{
        email: email,
        first_name: first_name,
        last_name: last_name
      }

      UserSettings.create_user(wo)
    end

  {:error, message} ->
    IO.inspect(message)
end)

File.stream!("assets/equipment_type.csv")
|> CSV.decode()
|> Enum.each(fn
  {:ok,
   [
     equipment_type_name
   ]} ->
    if equipment_type_name != "equipment_type_name" do
      wo = %{
        name: equipment_type_name
      }

      EquipmentSettings.create_equipment_category(wo)
    end

  {:error, message} ->
    IO.inspect(message)
end)

File.stream!("assets/equipment_details.csv")
|> CSV.decode()
|> Enum.each(fn
  {:ok,
   [
     facility,
     equipment,
     equipment_desription,
     equipment_type
   ]} ->
    if equipment_desription != "equipment_desription" do
      category_id = EquipmentCategory |> where(name: ^equipment_type) |> first() |> Repo.one()

      wo = %{
        variant: equipment_desription,
        brand_name: equipment,
        serial_no: facility,
        equipment_category_id: Map.get(category_id, :id)
      }

      EquipmentSettings.create_equipment(wo)
    end

  {:error, message} ->
    IO.inspect(message)
end)

File.stream!("assets/activity.csv")
|> CSV.decode()
|> Enum.each(fn
  {:ok,
   [
     plan_template,
     activity_name,
     check_list
   ]} ->
    if activity_name != "activity_name" do

      wo = %{
        name: activity_name,
        description: activity_name,
        time_to_finish: Time.utc_now(),
        checklists: [%{name: check_list, description: check_list}]
      }

      TaskSettings.create_task(wo)
    end

  {:error, message} ->
    IO.inspect(message)
end)

File.stream!("assets/check_points.csv")
|> CSV.decode()
|> Enum.each(fn
  {:ok,
   [
     check_list_name,
     check_points_name,
     type
   ]} ->
    if check_points_name != "check_points_name" do
      checklist_id = Checklist |> where(name: ^check_list_name) |> first() |> Repo.one()

      wo = %{
        name: check_points_name,
        type: type,
        checklist_id:
          case is_nil(checklist_id) do
            false -> Map.get(checklist_id, :id)
            true -> nil
          end
      }

      TaskSettings.create_checkpoint(wo)
    end

  {:error, message} ->
    IO.inspect(message)
end)

File.stream!("assets/plan_template.csv")
|> CSV.decode()
|> Enum.each(fn
  {:ok,
   [
     name,
     activity_name,
     planning
   ]} ->
    if name != "name" do
      equipment_category_id =
        EquipmentCategory |> Repo.all() |> Enum.shuffle() |> Enum.take(1) |> hd

      task_ids = Task |> where(name: ^activity_name) |> first() |> Repo.one()
      IO.inspect(task_ids)

      wo = %{
        name: name,
        description: name,
        equipment_category_id: Map.get(equipment_category_id, :id),
        planning: planning,
        tasks: [Map.get(task_ids, :id)]
      }

      ProjectSettings.create_project_type(wo)
    end

  {:error, message} ->
    IO.inspect(message)
end)

File.stream!("assets/maintaince_planning.csv")
|> CSV.decode()
|> Enum.each(fn
  {:ok,
   [
     name,
     type,
     equipment,
     frequency,
     day_of_week,
     fortnite,
     month,
     day_of_month,
     start_date,
     end_date,
     assigned_to,
     start_hour,
     end_hour,
     description
   ]} ->
    if name != "name" do
      user_id = User |> where(first_name: ^assigned_to) |> first() |> Repo.one()
      equipment_name_spilt = String.split(equipment, " ") |> hd
      equipment_ids =
        Equipment |> where(brand_name: ^equipment_name_spilt) |> Repo.all()
      project_type_ids = ProjectType |> where(planning: ^description) |> Repo.all()

      if length(project_type_ids) != 0 && length(equipment_ids) != 0 do
        project_type_ids = ProjectType |> where(planning: ^description) |> Repo.all()
        equipment_id = equipment_ids |> Enum.map(fn x -> Map.get(x, :id) end) |> hd
        IO.inspect equipment_ids
        project_type_id = project_type_ids
        |> Enum.map(fn x -> Map.get(x, :id) end)
        |> hd
        ect = %{
          equipment_category_id: equipment_ids |> Enum.map(fn x -> Map.get(x, :equipment_category_id) end) |> hd
        }
        project_type = ProjectSettings.get_project_type!(project_type_id)
        ProjectSettings.update_project_type(project_type, ect)

        wo = %{
          name: name,
          type: type,
          schedule_type: frequency,
          day_of_month: day_of_month,
          fortnite: fortnite,
          day_of_week: day_of_week,
          month: month,
          description: description,
          start_hour: start_hour,
          end_hour: end_hour,
          start_date: start_date,
          end_date: end_date,
          status: "Not Started",
          users:
            case is_nil(Map.get(user_id, :id)) do
              false -> [Map.get(user_id, :id)]
              true -> nil
            end,
          equipment_id: equipment_id,
          project_type_id: project_type_id
        }

        Projects.create_project(wo) |> IO.inspect()
      end
    end

  {:error, message} ->
    IO.inspect(message)
end)

# Projects.get_projects_for_work_order_creation()

# NextWorkOrder.get_list()
# get_list = Projects.list_projects()

# # IO.inspect get_list

# Enum.map(get_list, fn x -> next_work_order(x) end)

# fn next_work_order(x) do
#     IO.inspect x.schedule_type
# end

TimezoneSetting.build_tzdb()
