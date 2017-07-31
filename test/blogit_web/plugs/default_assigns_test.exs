defmodule BlogitWeb.Plugs.DefaultAssignsTest do
  use BlogitWeb.ConnCase

  test "assigns the values passed on initializiation as assigns of the " <>
  "connection", %{conn: conn} do
    conn = BlogitWeb.Plugs.DefaultAssigns.call(conn, a: 1, b: 2)

    assert conn.assigns == %{a: 1, b: 2}
  end

  test "if the value is function, calls it with the connection as an " <>
  "argument to compute the value", %{conn: conn} do
    conn = BlogitWeb.Plugs.DefaultAssigns.call(conn, a: &(&1.remote_ip))

    assert conn.assigns[:a] == conn.remote_ip
  end
end

