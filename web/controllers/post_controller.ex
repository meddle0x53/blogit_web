defmodule BlogitWeb.PostController do
  use BlogitWeb.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", posts: Repo.all(Blogit.Post)
  end
end

