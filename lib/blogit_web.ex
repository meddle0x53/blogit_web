defmodule BlogitWeb do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(BlogitWeb.Web.Endpoint, [])
    ]

    opts = [strategy: :one_for_one, name: BlogitWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
