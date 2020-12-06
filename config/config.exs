# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :by,
  namespace: BY,
  ecto_repos: [BY.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :by, BYWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Pjme1S/ohPmGqfPyHVw4PYkHaXswiVLj8fLL+W00A74AwlO92eRinHZRlpReOrCc",
  render_errors: [view: BYWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: BY.PubSub,
  live_view: [signing_salt: "wx7GooKL"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
