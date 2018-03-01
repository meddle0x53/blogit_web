defmodule BlogitWeb.Web.Gettext do
  use Gettext, otp_app: :elixirlang

  def supported_locales do
    Blogit.Settings.languages()
  end
end
