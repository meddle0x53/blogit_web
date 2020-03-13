defmodule BlogitWeb.Web.PostView do
  use BlogitWeb.Web, :view

  def title(%{post: %{meta: %{title: title}}}), do: title
  def title(%{blog: %{title: title}}), do: title
  def title(_), do: "Blogit"

  def render_category(conn, %{category: category}) do
    render_category(conn, %{meta: %{category: category}})
  end

  def render_category(
        conn,
        %{meta: %{category: category}}
      )
      when is_nil(category) do
    uncategorized = gettext("uncategorized")
    render_category_text(category_span(conn, uncategorized))
  end

  def render_category(conn, %{meta: %{category: category}}) do
    categorized = gettext("Categorized in ")
    render_category_text(categorized <> category_span(conn, category))
  end

  def post_image(conn, %{title_image_path: title_image_path}) do
    post_image(conn, %{meta: %{title_image_path: title_image_path}})
  end

  def post_image(_, %{meta: %{title_image_path: nil}}), do: ""

  def post_image(conn, %{meta: %{title_image_path: path}}) do
    src = Routes.static_url(conn, BlogitWeb.Web.LayoutView.blog_assets_path(path))
    img = "<img src=#{src} style='width: 100%; max-height: 300px;' />"

    {:safe, img <> "<hr />"}
  end

  def render_tags(%{tags: tags}), do: render_tags(%{meta: %{tags: tags}})
  def render_tags(%{meta: %{tags: []}}), do: ""

  def render_tags(%{meta: %{tags: tags}}) do
    description = gettext("Tagged in")
    tag_names = tags |> Enum.join(", ")
    tags_span = "<span class='post-tag-names'>#{tag_names}</span>"

    {:safe, "<div class='post-tags'>#{description} #{tags_span}</div>"}
  end

  def disqus_url(conn) do
    disqus_host = Application.get_env(:blogit_web, BlogitWeb.Web.Endpoint)[:disqus_host]

    if disqus_host do
      disqus_host
    else
      url = Application.get_env(:blogit_web, BlogitWeb.Web.Endpoint)[:url]

      if url && url[:host] do
        url[:host]
      else
        conn.host |> String.replace(".", "-")
      end
    end
  end

  defp category_span(conn, category) do
    category_link = """
      <a href="#{post_path(conn, :index, category: category)}">#{category}</a>
    """

    "<span class=post-category-name>#{category_link}</span>"
  end

  defp render_category_text(text) do
    {:safe, "<div class='post-category'>#{text}</div>"}
  end

  defp format_date(conn, date) do
    locale = BlogitWeb.Web.LayoutView.real_locale(conn) |> String.to_atom()
    Calendar.Strftime.strftime!(date, "%A, %d %B %Y, %H:%M", locale)
  end
end
