defmodule BlogitWeb.Plugs.LocaleByReferer do
  import Plug.Conn

  def init(assigns), do: assigns

  def call(conn, assigns) do
    case List.keyfind(conn.req_headers, "referer", 0) do
      {"referer", referer} ->
        IO.puts conn.request_path
        IO.puts referer
        conn
      nil -> conn
    end
  end
end
