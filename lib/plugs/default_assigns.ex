defmodule DefaultAssigns do
  import Plug.Conn

  def init(conf), do: conf

  def call(conn, conf) do
    Enum.reduce(conf, conn, fn {k, v}, conn ->
      assign_value(conn, k, v)
    end)
  end

  defp assign_value(conn, k, v) when is_function(v) do
    assign(conn, k, v.(conn))
  end
  defp assign_value(conn, k, v), do: assign(conn, k, v)
end
