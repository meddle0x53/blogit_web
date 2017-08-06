defmodule BlogitWeb.PostControllerTest do
  use BlogitWeb.ConnCase

  setup_all do
    Application.put_env(:blogit_web, :backend_implementation, DummyBlogit); :ok
  end

  describe "GET /posts" do
    test "returns first four post previews", %{conn: conn} do
      conn = get conn, "/posts"

      assert html_response(conn, 200) =~ DummyBlogitHTML.en_post_html()
    end
  end
end
