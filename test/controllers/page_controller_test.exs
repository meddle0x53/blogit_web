defmodule BlogitWeb.PageControllerTest do
  use BlogitWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 302) =~
      ~s[You are being <a href="/posts">redirected</a>]
  end

  test "GET / with default locale", %{conn: conn} do
    conn = get conn, "/en"
    assert html_response(conn, 302) =~
      ~s[You are being <a href="/posts">redirected</a>]
  end

  test "GET / with alternative locale", %{conn: conn} do
    conn = get conn, "/bg"
    assert html_response(conn, 302) =~
    ~s[You are being <a href="/bg/posts">redirected</a>]
  end
end
