# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :gather,
  ecto_repos: [Gather.Repo]

# Configures the endpoint
config :gather, GatherWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pQbljhzFmGoQLXZuzh3jS05aAe7zKqMOu+fc6pHk9j/tz6TOFmxpbwuu5srUf4up",
  render_errors: [view: GatherWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Gather.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures the authentication options
config :gather, Gather.Accounts.Guardian,
  issuer: "gather",
  # FIXME
  secret_key: "q6UtrjGSADXmtiRjCSn39agycN1U5x6AWc6jZa6TQ1Q1qPfM0iV0VbsjaHPVfWdB"


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
