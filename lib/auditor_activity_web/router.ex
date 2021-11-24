defmodule AuditorActivityWeb.Router do
  use AuditorActivityWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:put_root_layout, {AuditorActivityWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(CORSPlug, origin: "*")
  end

  scope "/", AuditorActivityWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
    # live "/", PageLive, :index
    resources("/skills", SkillController)
  end

  scope "/api", AuditorActivityWeb do
    pipe_through(:api)

    resources("/equipment_categories", EquipmentCategoryController, except: [:new, :edit])

    get(
      "/get_equipments_by_equipment_category_id/:id",
      EquipmentCategoryController,
      :get_equipments_by_equipment_category_id
    )

    resources("/equipments", EquipmentController, except: [:new, :edit])
    resources("/checklists", ChecklistController, except: [:new, :edit])
    # resources "/checkpoints", CheckpointController, except: [:new, :edit]
    resources("/projecttypes", ProjectTypeController, except: [:new, :edit])
    resources("/projects", ProjectController, except: [:new, :edit])
    resources("/tasks", TaskController, except: [:new, :edit])
    resources("/users", UserController, except: [:new, :edit])
    resources("/workorders", WorkOrderController, except: [:new, :edit])
    resources("/workordertasks", WorkOrderTaskController, except: [:new, :edit])
    resources("/workorderchecklists", WorkOrderChecklistController, except: [:new, :edit])
    resources("/workordercheckpoints", WorkOrderCheckpointController, except: [:new, :edit])
    resources("/timezones", TimezoneController, except: [:new, :edit])
    resources("/teams", TeamController, except: [:new, :edit])
    resources("/team_templates", TeamTemplateController, except: [:new, :edit])
    resources("/skills", SkillController, except: [:new, :edit])
    resources("/shift_times", ShiftTimeController, except: [:new, :edit])

    # get "/checklists/:checklist_id/checkpoints", ChecklistController, :checkpoints
    post("/tasks/:task_id/status", TaskController, :status_update)
    post("/projects/:project_id/status", ProjectController, :status_update)

    put("/users/:id/activate", UserController, :activate)
    put("/users/:id/deactivate", UserController, :deactivate)

    get("/get_workorders", WorkOrderController, :get_workorders)
    get("/list_workorders_by_date_range", WorkOrderController, :list_workorders_by_date_range)
    get("/get_workorders/:id", WorkOrderController, :get_workorders_by_id)
    get("/get_workorders_task/:id", WorkOrderTaskController, :show)
    get("/get_workorders_checklist/:id", WorkOrderChecklistController, :show)
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: AuditorActivityWeb.Telemetry)
    end
  end
end
