defmodule BlogitWeb.Plugs.LocalesTest do
  use BlogitWeb.Web.ConnCase

  test "assigns the locale present in the params to the connection if such " <>
         "exists and the locale is in Blogit.Settings.languages()",
       %{conn: conn} do
    conn = update_in(conn.params, fn _ -> %{"locale" => "bg"} end)
    conn = BlogitWeb.Plugs.Locales.call(conn, nil)

    assert conn.assigns == %{locale: "bg"}
  end

  test "assigns the default locale if there is no locale in the req params",
       %{conn: conn} do
    conn = update_in(conn.params, fn _ -> %{} end)
    conn = BlogitWeb.Plugs.Locales.call(conn, nil)

    assert conn.assigns == %{locale: Blogit.Settings.default_language()}
  end

  test "assigns the default locale if the locale in the req params is not " <>
         "in Blogit.Settings.languages()",
       %{conn: conn} do
    conn = update_in(conn.params, fn _ -> %{"locale" => "sada"} end)
    conn = BlogitWeb.Plugs.Locales.call(conn, nil)

    assert conn.assigns == %{locale: Blogit.Settings.default_language()}
  end

  test "sets the assigned locale to Gettext", %{conn: conn} do
    conn = update_in(conn.params, fn _ -> %{"locale" => "bg"} end)
    BlogitWeb.Plugs.Locales.call(conn, nil)

    assert Gettext.get_locale(BlogitWeb.Web.Gettext) == "bg"
  end
end
