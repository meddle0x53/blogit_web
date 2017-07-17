defmodule BlogitWeb.Gettext do
  use Gettext, otp_app: :blogit_web

  def supported_locales do
    Blogit.Settings.languages()
  end

  defp config, do: Application.get_env(:blogit_web, __MODULE__)
end
