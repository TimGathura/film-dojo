# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :film_dojo,
  ecto_repos: [FilmDojo.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :film_dojo, FilmDojoWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: FilmDojoWeb.ErrorHTML, json: FilmDojoWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: FilmDojo.PubSub,
  live_view: [signing_salt: "bsGFSgMI"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :film_dojo, FilmDojo.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  film_dojo: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  film_dojo: [
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





# < < < Custom configs > > >
config :mime, :types, %{
  "video/mp4" => ["mp4"],
  "video/quicktime" => ["mov"],
  "video/x-msvideo" => ["avi"]
}

config :phoenix, :endpoint,
http: [protocol_options: [max_request_line_length: 8192, max_header_value_length: 8192]]
