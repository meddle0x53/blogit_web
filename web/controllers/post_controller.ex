defmodule BlogitWeb.PostController do
  use BlogitWeb.Web, :controller

  plug :put_layout, "post.html"
  plug DefaultAssigns, blog: &__MODULE__.blog/0
  plug :last_posts

  def index(conn, params) when map_size(params) == 0 do
    render_posts(conn, Repo.all(Blogit.Post))
  end

  def index(conn, params = %{"category" => "uncategorized"}) do
    index(conn, %{params | "category" => nil})
  end

  def index(conn, params) do
    render_posts(conn, BlogitWeb.Posts.filter_by_params(params))
  end

  def show(conn, %{"name" => name}) do
    render_post(conn, Repo.get(Blogit.Post, name))
  end

  def blog, do: Repo.get(Blogit.Configuration, nil)

  defp render_posts(conn, posts), do: render conn, "index.html", posts: posts

  defp render_post(conn, :error) do
    conn
    |> put_status(:not_found)
    |> render("404.html")
  end

  defp render_post(conn, post) do
    render(
      conn, "show.html", post: post
    )
  end

  defp last_posts(conn, _params) do
    assign(conn, :last_posts, Repo.all(Blogit.Post, 5))
  end
end
