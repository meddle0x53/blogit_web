defmodule BlogitWeb.Web.LayoutView do
  use BlogitWeb.Web, :view

  def has_social_links?(%{social: nil}), do: false
  def has_social_links?(%{social: social}) do
    social["rss"] || social["stars_for_blogit"] || social["facebook"] ||
    social["github"] || social["twitter"]
  end

  def blog_assets_folder do
    Application.get_env(:blogit, :assets_path, "assets")
  end

  def blog_assets_path(image), do: "/custom/#{blog_assets_folder()}/#{image}"

  def blog_image_styles(_, %{blog: %{background_image_path: nil}}), do: ""

  def blog_image_styles(conn, %{blog: %{background_image_path: path}}) do
    styles = """
    <style>
      header.header {
        background: url('#{static_path(conn, blog_assets_path(path))}');
        background-position: right 10px top;
        min-height: 300px;
        background-repeat: no-repeat;
      }
    </style>
    """
    {:safe, styles}
  end

  def blog_logo(_, %{blog: %{logo_path: nil}}), do: ""
  def blog_logo(conn, %{blog: %{logo_path: path}}) do
    src = static_path(conn, blog_assets_path(path))

    html = """
    <div class="blog-logo">
      <img src="#{src}" />
    </div>
    """

    {:safe, html}
  end

  def blog_custom_styles(_, %{blog: %{styles_path: nil}}), do: ""

  def blog_custom_styles(conn, %{blog: %{styles_path: path}}) do
    path = static_path(conn, blog_assets_path(path))
    styles = "<link rel='stylesheet' href='#{path}'>"

    {:safe, styles}
  end

  def current_locale do
    Gettext.get_locale(BlogitWeb.Web.Gettext)
  end

  def language_annotations(conn) do
    Blogit.Settings.languages()
    |> Enum.reject(fn l -> l == Gettext.get_locale(BlogitWeb.Web.Gettext) end)
    |> Enum.concat(["x-default"])
    |> Enum.map(fn l ->
      case l do
        "x-default" -> {"x-default", localized_url(conn, "")}
        l -> {l, localized_url(conn, "/#{l}")}
      end
    end)
  end

  def localized_url(conn, alt) do
    path = ~r/\/#{Gettext.get_locale(BlogitWeb.Web.Gettext)}(\/(?:[^?]+)?|$)/
           |> Regex.replace(conn.request_path, "#{alt}\\1")

    Phoenix.Router.Helpers.url(BlogitWeb.Web.Router, conn) <> path
  end

  def language_links(conn) do
    Blogit.Settings.languages()
    |> Enum.map(fn lang ->
      link =
        if lang != Blogit.Settings.default_language() do
          "/#{lang}" <> BlogitWeb.Web.Router.Helpers.post_path(conn, :index)
        else
          BlogitWeb.Web.Router.Helpers.post_path(conn, :index)
        end

      text = Gettext.gettext(BlogitWeb.Web.Gettext, lang)
      class = if lang == conn.assigns[:locale] do
        "active"
      else
        "inactive"
      end
      {link, text, class}
    end)
  end

  def real_locale(conn) do
    Application.get_env(:elixirlang, :locales_map, %{})
    |> Map.get(conn.assigns[:locale], conn.assigns[:locale])
  end
end
