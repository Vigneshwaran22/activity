# # In this file, we load production configuration and secrets
# # from environment variables. You can also hardcode secrets,
# # although such is generally not recommended and you have to
# # remember to add this file to your .gitignore.
# import Config

# database_url =
#   System.get_env("DATABASE_URL") ||
#     raise """
#     environment variable DATABASE_URL is missing.
#     For example: ecto://USER:PASS@HOST/DATABASE
#     """

# config :auditor_activity, AuditorActivity.Endpoint, server: true # uncomment me!

# # config :auditor_activity, AuditorActivity.Repo,
# #   # ssl: true,
# #   url: database_url,
# #   pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

# secret_key_base =
#   System.get_env("SECRET_KEY_BASE") ||
#     raise """
#     environment variable SECRET_KEY_BASE is missing.
#     You can generate one by calling: mix phx.gen.secret
#     """

# config :auditor_activity, AuditorActivityWeb.Endpoint,
#   http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")],
#   secret_key_base: secret_key_base

#   # Configure your database
# config :auditor_activity, AuditorActivityWeb.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   username: "postgres",
#   password: "postgres",
#   database: "auditor_activity",
#   pool_size: 15
# # ## Using releases (Elixir v1.9+)
# #
# # If you are doing OTP releases, you need to instruct Phoenix
# # to start each relevant endpoint:
# #
# #     config :auditor_activity, AuditorActivityWeb.Endpoint, server: true
# #
# # Then you can assemble a release by calling `mix release`.
# # See `mix help release` for more information.

import Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).

config :auditor_activity, AuditorActivityWeb.Endpoint, server: true # uncomment me!

config :auditor_activity, AuditorActivityWeb.Endpoint,
  secret_key_base: "WaP6gm1wk7/A54epNVktRJNpiQl4R5icUtXpF5LEQ1On0SWO+NyOoZwpMMQr1qJV"

# Configure your database
config :auditor_activity, AuditorActivity.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "atribs2020",
  database: "auditor_activity_prod",
  pool_size: 15
