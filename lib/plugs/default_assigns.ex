defmodule DefaultAssigns do
  import Plug.Conn

  def init(assigns), do: assigns

  def call(conn, assigns) do
    Enum.reduce assigns, conn, fn {k, v}, conn ->
      assign_value(conn, k, v)
    end
  end

  defp assign_value(conn, k, v) when is_function(v) do
    Plug.Conn.assign(conn, k, v.())
  end
  defp assign_value(conn, k, v), do: Plug.Conn.assign(conn, k, v)
end
