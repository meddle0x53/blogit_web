defmodule BlogitWeb.PostView do
  use BlogitWeb.Web, :view

  def title(%{meta: %{title: title}}), do: title
  def title(_), do: "Blogit"

  def render_category(%{meta: %{category: category}}) when is_nil(category) do
    uncategorized = gettext "Uncategorized"
    render_category_text(category_span(uncategorized))
  end

  def render_category(%{meta: %{category: category}}) do
    categorized = gettext "Categorized in "
    render_category_text(categorized <> category_span(category))
  end

  def post_image(_, %{meta: %{title_image_path: nil}}), do: ""

  def post_image(conn, %{meta: %{title_image_path: path}}) do
    src = static_path(conn, BlogitWeb.LayoutView.blog_image_path(path))
    img = "<img src=#{src} style='width: 100%;' />"

    {:safe, img <> "<hr />"}
  end

  def render_tags(%{meta: %{tags: []}}), do: ""
  def render_tags(%{meta: %{tags: tags}}) do
    description = gettext "Tagged in"
    tag_names = tags |> Enum.join(", ")
    tags_span = "<span class='post-tag-names'>#{tag_names}</span>"

    {:safe, "<div class='post-tags'>#{description} #{tags_span}</div>" }
  end

  defp category_span(category) do
    "<span class=post-category-name>#{category}</span>"
  end

  defp render_category_text(text) do
    {:safe, "<div class='post-category'>#{text}</div>"}
  end
end
