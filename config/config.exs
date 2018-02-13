use Mix.Config

# General application configuration
config :elixirlang,
  ecto_repos: [BlogitWeb.Repo]

# Configures the endpoint
config :elixirlang, BlogitWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Sb/ttEadRlXB1E+P8/em9tXKUpBgGyf/mi7WwoAbhwYOf1EfsGILRZthHTXNDk2/",
  render_errors: [view: BlogitWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BlogitWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :elixirlang, BlogitWeb.Gettext, default_locale: "en"
config :calendar, :translation_module, CalendarTranslations.Translations

import_config "#{Mix.env}.exs"
