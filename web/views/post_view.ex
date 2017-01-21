defmodule BlogitWeb.PostView do
  use BlogitWeb.Web, :view

  def title(%{title: title}), do: title
  def title(_), do: "Blogit"
end
