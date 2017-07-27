defmodule BlogitWeb.PageControllerTest do
  use BlogitWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 302) =~
      ~s[You are being <a href="/posts">redirected</a>]
  end
end
