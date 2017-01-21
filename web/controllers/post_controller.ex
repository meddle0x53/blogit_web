defmodule BlogitWeb.PostController do
  use BlogitWeb.Web, :controller

  plug :put_layout, "post.html"

  def index(conn, _params) do
    render conn, "index.html", posts: Repo.all(Blogit.Post)
  end

  def show(conn, %{"name" => name}) do
    render(
      conn, "show.html",
      post: Repo.get(Blogit.Post, name), posts: Repo.all(Blogit.Post, 5)
    )
  end
end
