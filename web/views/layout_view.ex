defmodule BlogitWeb.LayoutView do
  use BlogitWeb.Web, :view

  def blog_image_path(image) do
    "/custom/#{Application.get_env(:blogit, :assets_path, "assets")}/#{image}"
  end
end
