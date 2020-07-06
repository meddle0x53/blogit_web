defmodule BlogitWeb.Web.Gettext do
  use Gettext, otp_app: :blogit_web

  def supported_locales do
    Blogit.Settings.languages()
  end
end
