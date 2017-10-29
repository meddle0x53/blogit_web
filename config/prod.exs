use Mix.Config

config :blogit_web, BlogitWeb.Endpoint,
  http: [port: 8888],
  url: [host: "themeddle.com", port: 80],
  cache_static_manifest: "priv/static/manifest.json",
  server: true,
  root: ".",
  disqus_host: "themeddle-com",
  version: Mix.Project.config[:version]

config :blogit_web, locales_map: %{"mu" => "en"}

config :phoenix, :serve_endpoints, true

# Do not print debug messages in production
config :logger, level: :info, format: "[$level] $message\n",
  backends: [
    { LoggerFileBackend, :error_log }, { LoggerFileBackend, :info_log },
    :console
  ]

config :logger, :error_log, path: "log/error.log", level: :error
config :logger, :info_log, path: "log/info.log", level: :info

config :blogit,
  repository_url: "https://github.com/meddle0x53/themeddle",
  polling: true, poll_interval: 300, max_lines_in_preview: 5,
  languages: ~w(en bg mu)
