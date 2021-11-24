defmodule AuditorActivity.Repo do
  use Ecto.Repo,
    otp_app: :auditor_activity,
    adapter: Ecto.Adapters.Postgres

  use Scrivener
end
