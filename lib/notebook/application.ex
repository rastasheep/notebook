defmodule Notebook.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      NotebookWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:notebook, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Notebook.PubSub},
      # Start a worker by calling: Notebook.Worker.start_link(arg)
      # {Notebook.Worker, arg},
      # Start to serve requests, typically the last entry
      NotebookWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Notebook.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NotebookWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
