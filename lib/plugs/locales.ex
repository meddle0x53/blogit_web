defmodule BlogitWeb.Plugs.Locales do
  import Plug.Conn

  def init(assigns), do: assigns

  def call(conn, assigns) do
    locale = conn.params["locale"]

    language =
      if locale != nil && Enum.member?(Blogit.Settings.languages(), locale) do
        locale
      else
        Blogit.Settings.default_language()
      end

    Gettext.put_locale(BlogitWeb.Gettext, language)

    conn |> assign(:locale, language)
  end
end
