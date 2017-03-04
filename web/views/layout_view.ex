defmodule BlogitWeb.LayoutView do
  use BlogitWeb.Web, :view

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

  def blog_custom_styles(_, %{blog: %{styles_path: nil}}), do: ""

  def blog_custom_styles(conn, %{blog: %{styles_path: path}}) do
    path = static_path(conn, blog_assets_path(path))
    styles = "<link rel='stylesheet' href='#{path}'>"

    {:safe, styles}
  end
end
