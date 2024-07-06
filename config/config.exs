# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :notebook,
  generators: [timestamp_type: :utc_datetime],
  notebook_path: "~/.notebook/default",
  notes_dir: "notes",
  journals_dir: "journals"

# Configures the endpoint
config :notebook, NotebookWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: NotebookWeb.ErrorHTML, json: NotebookWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Notebook.PubSub,
  live_view: [signing_salt: "H2C8qIKt"]

config :bun,
  version: "1.1.18",
  default: [
    args: ~w(
    build js/app.js
    --outdir=../priv/static/assets
    --external /fonts/*
    --external /images/*
    --define process.env.IS_PREACT='false'
    --define process.env.NODE_ENV='development'
  ),
    cd: Path.expand("../assets", __DIR__),
    env: %{}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  notebook: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
