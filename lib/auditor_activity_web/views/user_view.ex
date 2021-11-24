defmodule AuditorActivityWeb.UserView do
  use AuditorActivityWeb, :view
  alias AuditorActivityWeb.{UserView, SkillView, TaskView, TeamView}

  def render("index.json", %{users: users}) do
    %{
      users: render_many(users.entries, UserView, "user.json"),
      page_number: users.page_number,
      page_size: users.page_size,
      total_entries: users.total_entries,
      total_pages: users.total_pages
    }
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      active_status: user.active_status,
      skills:
        case is_list(user.skills) do
          true -> render_many(user.skills, SkillView, "skills.json")
          false -> []
        end,
      tasks:
        case is_list(user.tasks) do
          true -> render_many(user.tasks, TaskView, "tasks.json")
          false -> []
        end,
      teams:
        case is_list(user.teams) do
          true -> render_many(user.teams, TeamView, "team.json")
          false -> []
        end
    }
  end
end
