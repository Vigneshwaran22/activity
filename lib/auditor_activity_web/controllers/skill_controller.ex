defmodule AuditorActivityWeb.SkillController do
  use AuditorActivityWeb, :controller

  alias AuditorActivity.Generic
  alias AuditorActivity.Generic.Skill

  def index(conn, _params) do
    skills = Generic.list_skills()
    render(conn, "index.html", skills: skills)
  end

  def new(conn, _params) do
    changeset = Generic.change_skill(%Skill{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"skill" => skill_params}) do
    case Generic.create_skill(skill_params) do
      {:ok, skill} ->
        conn
        |> put_flash(:info, "Skill created successfully.")
        |> redirect(to: Routes.skill_path(conn, :show, skill))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    skill = Generic.get_skill!(id)
    render(conn, "show.html", skill: skill)
  end

  def edit(conn, %{"id" => id}) do
    skill = Generic.get_skill!(id)
    changeset = Generic.change_skill(skill)
    render(conn, "edit.html", skill: skill, changeset: changeset)
  end

  def update(conn, %{"id" => id, "skill" => skill_params}) do
    skill = Generic.get_skill!(id)

    case Generic.update_skill(skill, skill_params) do
      {:ok, skill} ->
        conn
        |> put_flash(:info, "Skill updated successfully.")
        |> redirect(to: Routes.skill_path(conn, :show, skill))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", skill: skill, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    skill = Generic.get_skill!(id)
    {:ok, _skill} = Generic.delete_skill(skill)

    conn
    |> put_flash(:info, "Skill deleted successfully.")
    |> redirect(to: Routes.skill_path(conn, :index))
  end
end
# defmodule AuditorActivityWeb.SkillController do
#   use AuditorActivityWeb, :controller

#   alias AuditorActivity.Generic
#   alias AuditorActivity.Generic.Skill

#   action_fallback AuditorActivityWeb.FallbackController

#   def index(conn, %{"offset" => offset, "limit" => limit, "sort" => sort, "order" => order, "search" => search}) do
#     skills = Generic.list_skills(offset, limit, sort, order, search)
#     render(conn, "index.json", skills: skills)
#   end

#   def create(conn, %{"skill" => skill_params}) do
#     with {:ok, %Skill{} = skill} <- Generic.create_skill(skill_params) do
#       conn
#       |> put_status(:created)
#       |> put_resp_header("location", Routes.skill_path(conn, :show, skill))
#       |> render("show.json", skill: skill)
#     end
#   end

#   def show(conn, %{"id" => id}) do
#     skill = Generic.get_skill!(id)
#     render(conn, "show.json", skill: skill)
#   end

#   def update(conn, %{"id" => id, "skill" => skill_params}) do
#     skill = Generic.get_skill!(id)

#     with {:ok, %Skill{} = skill} <- Generic.update_skill(skill, skill_params) do
#       render(conn, "show.json", skill: skill)
#     end
#   end

#   def delete(conn, %{"id" => id}) do
#     skill = Generic.get_skill!(id)

#     with {:ok, %Skill{}} <- Generic.delete_skill(skill) do
#       send_resp(conn, :no_content, "")
#     end
#   end
# end
