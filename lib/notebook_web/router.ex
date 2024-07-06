defmodule NotebookWeb.Router do
  use NotebookWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {NotebookWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NotebookWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/journals", JournalLive.Index, :index
    live "/journals/:id", JournalLive.Show, :show

    live "/notes/:id", NoteLive.Show, :show

    live "/canvases/:id", CanvasLive.Show, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", NotebookWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:notebook, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: NotebookWeb.Telemetry
    end
  end
end

defimpl Phoenix.Param, for: Date do
  def to_param(date) do
    Date.to_iso8601(date)
  end
end
