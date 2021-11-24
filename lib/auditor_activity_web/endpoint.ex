defmodule AuditorActivityWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :auditor_activity

  # The session will be stored in the cookie and signed,            
  # this means its contents can be read but not tampered with.            
  # Set :encryption_salt if you would also like to encrypt it.            
  @session_options [
    store: :cookie,
    key: "_auditor_activity_app_key",
    signing_salt: "aaaaaaaa"
  ]

  socket("/socket", AuditorActivityWeb.UserSocket,
    websocket: true,
    longpoll: false
  )

  socket("/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]])

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug(Plug.Static,
    at: "/",
    from: :auditor_activity,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)
  )

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :auditor_activity
  end

  plug(Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"
  )

  plug(Plug.RequestId)
  plug(Plug.Telemetry, event_prefix: [:phoenix, :endpoint])

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug(Plug.Session, @session_options
    # store: :cookie,
    # key: "_auditor_activity_key",
    # signing_salt: "Id+6KOZY"
  )

  plug(CORSPlug)

  plug(AuditorActivityWeb.Router)

  def init(_key, config) do
    if config[:load_from_system_env] do
      port = String.to_integer(System.get_env("PORT") || "4000")
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
