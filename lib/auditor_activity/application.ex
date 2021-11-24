defmodule AuditorActivity.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      AuditorActivity.Repo,
      # Start the Telemetry supervisor            
      AuditorActivityWeb.Telemetry,            
      # Start the PubSub system            
      {Phoenix.PubSub, name: AuditorActivity.PubSub},            
      # Start the Endpoint (http/https)            
      AuditorActivityWeb.Endpoint,           
      # Start a worker by calling: AuditorActivity.Worker.start_link(arg)            
      # {AuditorActivity.Worker, arg}
      # Scheduler for creating jobs
      AuditorActivity.Scheduler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AuditorActivity.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    AuditorActivityWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
