defmodule BlogitWeb.ErrorViewTest do
  use BlogitWeb.Web.ConnCase, async: true

  import Phoenix.View

  test "render 500.html" do
    assert render_to_string(BlogitWeb.Web.ErrorView, "500.html", []) ==
           "Internal server error"
  end

  test "render any other" do
    assert render_to_string(BlogitWeb.Web.ErrorView, "505.html", []) ==
           "Internal server error"
  end
end
