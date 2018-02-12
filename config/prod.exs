use Mix.Config

config :elixirlang, BlogitWeb.Endpoint,
  http: [port: 8889],
  url: [host: "elixir-lang.bg", port: 80],
  cache_static_manifest: "priv/static/manifest.json",
  server: true,
  root: ".",
  disqus_host: "elixir-lang.bg",
  version: Mix.Project.config[:version]

config :phoenix, :serve_endpoints, true

config :logger, level: :info, format: "[$level] $message\n",
  backends: [
    { LoggerFileBackend, :error_log }, { LoggerFileBackend, :info_log },
    :console
  ]

config :logger, :error_log, path: "log/error.log", level: :error
config :logger, :info_log, path: "log/info.log", level: :info

config :blogit,
  repository_url: "https://github.com/ElixirCourse/blog-staging",
  polling: true, poll_interval: 300, max_lines_in_preview: 5,
  languages: ~w(bg en)
