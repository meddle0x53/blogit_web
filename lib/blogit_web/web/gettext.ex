defmodule BlogitWeb.Plural do
  @behaviour Gettext.Plural

  def nplurals("mu"), do: 1

  def plural("mu", _), do: 0

  # Fallback to Gettext.Plural
  def nplurals(locale), do: Gettext.Plural.nplurals(locale)
  def plural(locale, n), do: Gettext.Plural.plural(locale, n)
end

defmodule BlogitWeb.Web.Gettext do
  use Gettext, otp_app: :blogit_web, plural_forms: BlogitWeb.Plural

  def supported_locales do
    Blogit.Settings.languages()
  end
end
