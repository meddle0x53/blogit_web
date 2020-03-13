defmodule BlogitWeb.Web.ErrorView do
  @moduledoc """
  A set of functions for rendering of errors.
  """
  use BlogitWeb.Web, :view

  def render("404.html", assigns) do
    render(
      BlogitWeb.Web.PostView,
      "404.html",
      Map.merge(assigns, %{layout: {BlogitWeb.Web.LayoutView, "app.html"}})
    )
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render("500.html", assigns)
  end
end
