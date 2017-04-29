# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :main,
  ecto_repos: [Main.Repo]

# Configures the endpoint
config :main, Main.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "NvMb0w3utBItncbo2emI9KPSFze4Rfu2k7Q2bYDnbUZyYfM5DwEVdfWsqpdlmoNs",
  render_errors: [view: Main.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Main.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: Main.User,
  repo: Main.Repo,
  module: Main,
  logged_out_url: "/",
  email_from_name: "Your Name",
  email_from_email: "yourname@example.com",
  opts: [:authenticatable, :recoverable, :lockable, :trackable, :unlockable_with_token, :registerable]

config :coherence, Main.Coherence.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "your api key here"
# %% End Coherence Configuration %%
