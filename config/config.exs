# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :auditor_activity,
  ecto_repos: [AuditorActivity.Repo]

# Configures the endpoint
config :auditor_activity, AuditorActivityWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "X7dxRU4D/+UdfvQaS+qTDZfUY1S3+t1FeYzKf0+7aqW/wQBHjLFN0gS+U/cu2R9C",
  render_errors: [view: AuditorActivityWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: AuditorActivity.PubSub,            
  live_view: [signing_salt: "aaaaaaaa"]
# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :cors_plug,
  # origin: ["http://192.168.43.6:8080/"],
  # origin: ["http://localhost:8080/"],
  max_age: 86400,
  methods: ["GET", "POST", "PUT", "DELETE"]
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :logger,
  level: :debug

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :auditor_activity, AuditorActivity.Scheduler,
  jobs: [
    # Every minute
    # {"* * * * *",      {Heartbeat, :send, []}},
    # {"* * * * *", fn -> AuditorActivity.Pr  ojects.get_projects_for_work_order_creation() end},
    # Every 15 minutes
    # {"*/15 * * * *",   fn -> System.cmd("rm", ["/tmp/tmp_"]) end},
    # Runs on 18, 20, 22, 0, 2, 4, 6:
    # {"0 18-6/2 * * *", fn -> :mnesia.backup('/var/backup/mnesia') end},
    # Runs every midnight:
    # {"@daily", fn -> AuditorActivity.Projects.get_projects_for_work_order_creation() end}
    {"@daily", {AuditorActivity.Projects, :get_projects_for_work_order_creation, []}}
    # {"@daily", fn -> AuditorActivity.Projects.get_projects_for_work_order_creation() end}
  ]
