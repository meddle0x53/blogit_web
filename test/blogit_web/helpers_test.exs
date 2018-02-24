defmodule BlogitWeb.HelpersTest do
  use BlogitWeb.Web.ConnCase
  doctest BlogitWeb.Helpers

  def with_phoexni_endpoint(conn) do
    private = Map.put(conn.private, :phoenix_endpoint, BlogitWeb.Web.Endpoint)
    Map.put(conn, :private, private)
  end

  describe "localized_path" do
    test "generates the same path as `BlogitWeb.Web.Router.Helpers.post_path` " <>
    "if calling `BlogitWeb.Helpers.current_locale()` returns " <>
    "the default locale", %{conn: conn} do
      Gettext.put_locale(BlogitWeb.Web.Gettext, Blogit.Settings.default_language())

      path = BlogitWeb.Helpers.localized_path(conn, "post", :index)

      assert path == BlogitWeb.Web.Router.Helpers.post_path(conn, :index)
    end

    test "generates the a path prefixed by `/<current-locale>` " <>
    "if calling `BlogitWeb.Helpers.current_locale()` doesn't return " <>
    "the default locale", %{conn: conn} do
      assert Blogit.Settings.default_language() != "pl"
      Gettext.put_locale(BlogitWeb.Web.Gettext, "pl")

      path = BlogitWeb.Helpers.localized_path(conn, "post", :index)

      assert path == "/pl#{BlogitWeb.Web.Router.Helpers.post_path(conn, :index)}"
    end
  end

  describe "__using__" do
    defmodule TestMod do
      import BlogitWeb.Web.Router.Helpers, only: [static_path: 2, static_url: 2]

      use BlogitWeb.Helpers

      def try_static_path(conn, path), do: static_path(conn, path)
      def try_static_url(conn, path), do: static_url(conn, path)
    end

    test "modifies the `*_path` functions in the using module to use the " <>
    "current locale", %{conn: conn} do
      assert Blogit.Settings.default_language() != "pl"
      Gettext.put_locale(BlogitWeb.Web.Gettext, "pl")

      assert TestMod.post_path(conn, :index) == "/pl/posts"
    end

    test "modifies the `*_url` functions in the using module to use the " <>
    "current locale", %{conn: conn} do
      conn = with_phoexni_endpoint(conn)

      assert Blogit.Settings.default_language() != "pl"
      Gettext.put_locale(BlogitWeb.Web.Gettext, "pl")

      assert TestMod.post_url(conn, :index) == "http://localhost:4001/pl/posts"
    end

    test "the `*_path` functions are not modified if the current locale" <>
    "is the default Blogit language", %{conn: conn} do
      Gettext.put_locale(BlogitWeb.Web.Gettext, Blogit.Settings.default_language())

      assert TestMod.post_path(conn, :index) == "/posts"
    end

    test "the `*_url` functions are not modified if the current locale" <>
    "is the default Blogit language", %{conn: conn} do
      conn = with_phoexni_endpoint(conn)
      Gettext.put_locale(BlogitWeb.Web.Gettext, Blogit.Settings.default_language())

      assert TestMod.post_url(conn, :index) == "http://localhost:4001/posts"
    end

    test "doesn't modify `static_path` with the current locale",
    %{conn: conn} do
      conn = with_phoexni_endpoint(conn)

      assert Blogit.Settings.default_language() != "pl"
      Gettext.put_locale(BlogitWeb.Web.Gettext, "pl")

      assert TestMod.try_static_path(conn, "/images") == "/images"
    end

    test "doesn't modify `static_url` with the current locale", %{conn: conn} do
      conn = with_phoexni_endpoint(conn)

      assert Blogit.Settings.default_language() != "pl"
      Gettext.put_locale(BlogitWeb.Web.Gettext, "pl")

      assert TestMod.try_static_url(conn, "/images") ==
        "http://localhost:4001/images"
    end
  end
end
