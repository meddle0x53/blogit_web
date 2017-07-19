defmodule BlogitWeb.FeedController do
  use BlogitWeb.Web, :controller

  plug DefaultAssigns, blog: &__MODULE__.blog/1
  plug BlogitWeb.Plugs.Locales

  def index(conn, _params) do
    posts = Repo.all(Blogit.Post, 100, 1, conn.assigns[:locale])

    conn
    |> put_layout(:none)
    |> put_resp_content_type("application/xml")
    |> render("index.xml", items: posts)
  end

  def blog(conn), do: Repo.get(Blogit.Configuration, nil, conn.assigns[:locale])
end
