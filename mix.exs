defmodule BlogitWeb.Mixfile do
  use Mix.Project

  def project do
    [
      app: :blogit_web,
      version: "0.15.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [mod: {BlogitWeb, []},
     applications: [:blogit, :calendar, :phoenix, :phoenix_pubsub,
      :phoenix_html, :plug_cowboy,:plug, :logger, :gettext, :edeliver],
    included_applications: [
      :calendar_translations, :earmark, :git_cli, :logger_file_backend
    ]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [{:phoenix, "~> 1.4"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:jason, "~> 1.0"},
     {:plug_cowboy, "~> 2.0"},
     {:plug, "~> 1.7"},
     {:calendar, "~> 0.17"},
     {:calendar_translations, "~> 0.0.4"},
     {:edeliver, "~> 1.4"},
     {:distillery, "~> 1.1"},
     {:logger_file_backend, "0.0.9"},
     {:blogit, "~> 1.2"}
    ]
  end

  defp aliases do
    []
  end
end
