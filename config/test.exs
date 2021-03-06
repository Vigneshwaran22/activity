use Mix.Config

# Configure your database
config :auditor_activity, AuditorActivity.Repo,
  username: "postgres",
  password: "atribs2020",
  database: "auditor_activity_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :auditor_activity, AuditorActivityWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
