use Mix.Config

config :blogit_web, BlogitWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :blogit,
       repository_url: "spec/data", polling: false,
       repository_provider: Blogit.RepositoryProviders.Memory,
       languages: ~w(en)
