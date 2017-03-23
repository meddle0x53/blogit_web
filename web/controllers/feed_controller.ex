defmodule BlogitWeb.FeedController do
  use BlogitWeb.Web, :controller

  plug DefaultAssigns, blog: &__MODULE__.blog/0

  def index(conn, _params) do
    posts = Repo.all(Blogit.Post, 100, 1)

    conn
    |> put_layout(:none)
    |> put_resp_content_type("application/xml")
    |> render("index.xml", items: posts)
  end

  def blog, do: Repo.get(Blogit.Configuration, nil)
end
