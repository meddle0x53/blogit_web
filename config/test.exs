use Mix.Config

config :blogit_web, BlogitWeb.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :blogit,
       repository_url: "spec/data", polling: false, languages: ~w(en bg),
       repository_provider: Blogit.RepositoryProviders.Memory
