defmodule BlogitWeb.PostControllerTest do
  use BlogitWeb.Web.ConnCase

  setup_all do
    Application.put_env(:elixirlang, :backend_implementation, DummyBlogit); :ok
  end

  describe "GET /posts" do
    test "returns first four post previews", %{conn: conn} do
      conn = get conn, "/posts"

      assert html_response(conn, 200) =~ DummyBlogitHTML.en_post_html()
    end

    test "supports paging with `page` and `per_page`", %{conn: conn} do
      conn = get conn, "/posts", %{page: "3", per_page: "1"}

      assert html_response(conn, 200) =~ DummyBlogitHTML.en_post_html3()
    end

    test "supports search with the `q` request param", %{conn: conn} do
      conn = get conn, "/posts", %{"q" => "Post Three"}

      refute html_response(conn, 200) =~ DummyBlogitHTML.en_post_html()
      assert html_response(conn, 200) =~ DummyBlogitHTML.en_post_html3()
    end

    test "supports filtering by author", %{conn: conn} do
      conn = get conn, "/posts", %{"author" => "andi"}

      refute html_response(conn, 200) =~ DummyBlogitHTML.en_post_html()
      assert html_response(conn, 200) =~ DummyBlogitHTML.en_post_html4()
    end

    test "supports filtering by category", %{conn: conn} do
      conn = get conn, "/posts", %{"category" => "Test"}

      refute html_response(conn, 200) =~ DummyBlogitHTML.en_post_html()
      assert html_response(conn, 200) =~ DummyBlogitHTML.en_post_html1()
    end

    test "supports filtering by year and month", %{conn: conn} do
      conn = get conn, "/posts", %{"year" => "2017", "month" => "3"}

      refute html_response(conn, 200) =~ DummyBlogitHTML.en_post_html()
      assert html_response(conn, 200) =~ DummyBlogitHTML.en_post_html4()
    end

    test "supports filtering by tags", %{conn: conn} do
      conn = get conn, "/posts", %{"tags" => "stuff"}

      refute html_response(conn, 200) =~ DummyBlogitHTML.en_post_html()
      assert html_response(conn, 200) =~ DummyBlogitHTML.en_post_html2()
    end

    test "assigns the pinned posts data to :pinned_posts", %{conn: conn} do
      conn = get conn, "/posts"

      refute is_nil(conn.assigns[:pinned_posts])
      assert conn.assigns[:pinned_posts] == [{"post2", "Post Two"}]
    end

    test "assigns the posts by dates statistics to `:posts_by_dates`",
    %{conn: conn} do
      conn = get conn, "/posts"

      refute is_nil(conn.assigns[:posts_by_dates])
      assert conn.assigns[:posts_by_dates] == [
       {2017, 7, 1}, {2017, 5, 1}, {2017, 4, 1}, {2017, 3, 1}
     ]
    end

    test "assigns the latest posts to `:last_posts`", %{conn: conn} do
      conn = get conn, "/posts"

      refute is_nil(conn.assigns[:last_posts])
      assert conn.assigns[:last_posts] |> Enum.map(&(&1.name)) ==
        ~w(post1 post2 post3 post4)
    end
  end

  describe "GET /:locale/posts" do
    test "returns post previews for the given locale", %{conn: conn} do
      conn = get conn, "/bg/posts"

      assert html_response(conn, 200) =~ DummyBlogitHTML.bg_post_html()
    end
  end

  describe "GET /posts/:name" do
    test "returns a post by it uniq name", %{conn: conn} do
      conn = get conn, "/posts/post3"

      assert html_response(conn, 200) =~ DummyBlogitHTML.en_post_whole_html3()
    end

    test "returns a not found page if the post is not found", %{conn: conn} do
      conn = get conn, "/posts/post33"

      assert html_response(conn, 404) =~ ~S(<div class="not-found"></div>)
    end
  end

  describe "GET /:locale/posts/:name" do
    test "returns a post by it uniq name", %{conn: conn} do
      conn = get conn, "/bg/posts/публикация1"

      assert html_response(conn, 200) =~ DummyBlogitHTML.bg_post_whole_html1()
    end

    test "returns a not found page if the post is not found", %{conn: conn} do
      conn = get conn, "/bg/posts/post3"

      assert html_response(conn, 404) =~ ~S(<div class="not-found"></div>)
    end
  end
end
