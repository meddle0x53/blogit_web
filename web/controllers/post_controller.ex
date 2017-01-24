defmodule BlogitWeb.PostController do
  use BlogitWeb.Web, :controller

  plug :put_layout, "post.html"
  plug DefaultAssigns, blog: &__MODULE__.blog/0

  def index(conn, _params) do
    render conn, "index.html", posts: Repo.all(Blogit.Post)
  end

  def show(conn, %{"name" => name}) do
    render(
      conn, "show.html",
      post: Repo.get(Blogit.Post, name), posts: Repo.all(Blogit.Post, 5)
    )
  end

  def blog, do: Repo.get(Blogit.Configuration, nil)
end
