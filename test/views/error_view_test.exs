defmodule BlogitWeb.ErrorViewTest do
  use BlogitWeb.ConnCase, async: true

  import Phoenix.View

  test "render 500.html" do
    assert render_to_string(BlogitWeb.ErrorView, "500.html", []) ==
           "Internal server error"
  end

  test "render any other" do
    assert render_to_string(BlogitWeb.ErrorView, "505.html", []) ==
           "Internal server error"
  end
end
