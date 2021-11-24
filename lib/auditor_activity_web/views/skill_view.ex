defmodule AuditorActivityWeb.SkillView do
  use AuditorActivityWeb, :view
end

# defmodule AuditorActivityWeb.SkillView do
#   use AuditorActivityWeb, :view
#   alias AuditorActivityWeb.SkillView

#   def render("index.json", %{skills: skills}) do
#     %{
#       skills:
#         render_many(
#           skills.entries,
#           SkillView,
#           "skills.json"
#         ),
#       page_number: skills.page_number,
#       page_size: skills.page_size,
#       total_entries: skills.total_entries,
#       total_pages: skills.total_pages
#     }
#     # %{data: render_many(skills, SkillView, "skill.json")}
#   end

#   def render("show.json", %{skill: skill}) do
#     %{data: render_one(skill, SkillView, "skill.json")}
#   end

#   def render("skill.json", %{skill: skill}) do
#     %{id: skill.id,
#       name: skill.name}
#   end

#   def render("skills.json", %{skill: skill}) do
#     %{id: skill.id,
#       name: skill.name}
#   end
# end
