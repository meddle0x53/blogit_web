defmodule BlogitWeb.Plugs.DefaultAssigns do
  @moduledoc """
  A plug for setting assigns before invoking controller functions.

  Example usage:
  ```
  plug BlogitWeb.Plugs.DefaultAssigns, my_key: 5
  ```

  Now in the controller function of the controller, invoking the `plug` macro
  the `assigns` will contain `my_key: 5`.

  If the value should be more dynamic and dependent on the current request,
  the value could be a function with one argument - connection. On request
  the function will be invoked with the `conn` structure and its return
  value will be set in the assigns:
  ```
  plug BlogitWeb.Plugs.DefaultAssigns, my_key: fn (conn) -> :something end
  ```
  """

  import Plug.Conn

  #############
  # Callbacks #
  #############

  def init(conf), do: conf

  def call(conn, conf) do
    Enum.reduce(conf, conn, fn {k, v}, conn ->
      assign_value(conn, k, v)
    end)
  end

  ###########
  # Private #
  ###########

  defp assign_value(conn, k, v) when is_function(v) do
    assign(conn, k, v.(conn))
  end

  defp assign_value(conn, k, v), do: assign(conn, k, v)
end
