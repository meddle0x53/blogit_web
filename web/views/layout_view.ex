defmodule BlogitWeb.LayoutView do
  use BlogitWeb.Web, :view

  def blog_image_path(image) do
    "/custom/#{Application.get_env(:blogit, :assets_path, "assets")}/#{image}"
  end

  def blog_image_styles(_, %{blog: %{background_image_path: nil}}), do: ""

  def blog_image_styles(conn, %{blog: %{background_image_path: path}}) do
    styles = """
    <style>
      header.header {
        background: url('#{static_path(conn, blog_image_path(path))}');
        background-position: center;
        min-height: 300px;
        background-repeat: no-repeat;
      }
    </style>
    """
    {:safe, styles}
  end
end
