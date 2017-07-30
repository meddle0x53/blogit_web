defmodule BlogitWeb.Plugs.Locales do
  @moduledoc """
  A plug for setting the locale of the request using the `:locale` path request
  parameter.

  The locale passed have to be a supported language by `Blogit`. In other words
  to be present in `Blogit.Settings.languages()`.

  If the locale is not set, the default one will be used. The default is
  returned by `Blogit.Settings.default_locale()`.

  The locale is set int he `assigns` of the connection and is set as locale for
  `Gettext` for the current request.
  """

  import Plug.Conn

  #############
  # Callbacks #
  #############

  def init(conf), do: conf

  def call(conn, _) do
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
