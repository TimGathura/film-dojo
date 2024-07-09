defmodule FilmDojo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FilmDojoWeb.Telemetry,
      FilmDojo.Repo,
      {DNSCluster, query: Application.get_env(:film_dojo, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FilmDojo.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FilmDojo.Finch},
      # Start a worker by calling: FilmDojo.Worker.start_link(arg)
      # {FilmDojo.Worker, arg},
      # Start to serve requests, typically the last entry
      FilmDojoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FilmDojo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FilmDojoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
