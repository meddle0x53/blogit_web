defmodule BlogitWeb.FeedController do
  @moduledoc """
  A controller module which provides RSS feed for the main stream of posts.

  Has only one action - `index` which returns the whole feed of post previews
  formatted as RSS XML.
  """
  use BlogitWeb.Web, :controller

  plug BlogitWeb.Plugs.DefaultAssigns, blog: &__MODULE__.blog/1
  plug BlogitWeb.Plugs.Locales

  def index(conn, _params) do
    posts = Repo.all(Blogit.Models.Post.Meta, 100, 1, conn.assigns[:locale])

    conn
    |> put_layout(:none)
    |> put_resp_content_type("application/xml")
    |> render("index.xml", items: posts)
  end

  def blog(conn) do
    Repo.get(Blogit.Models.Configuration, conn.assigns[:locale])
  end
end
