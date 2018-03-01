use Mix.Config

config :elixirlang, BlogitWeb.Web.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  disqus_host: "themeddle-com",
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]


# Watch static and templates for browser reloading.
config :elixirlang, BlogitWeb.Web.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/blogit_web/web/views/.*(ex)$},
      ~r{lib/blogit_web/web/templates/.*(eex)$}
    ]
  ]

config :logger, format: "[$level] $message\n",
  backends: [{LoggerFileBackend, :error_log}, :console]
config :logger, :error_log, path: "log/error.log", level: :error

config :phoenix, :stacktrace_depth, 20

config :blogit,
  repository_url: "https://github.com/ElixirCourse/blog-staging",
  polling: false, max_lines_in_preview: 5, languages: ~w(bg en)
