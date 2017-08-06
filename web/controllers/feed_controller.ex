defmodule BlogitWeb.FeedController do
  @moduledoc """
  A controller module which provides RSS feed for the main stream of posts.

  Has only one action - `index` which returns the whole feed of post previews
  formatted as RSS XML.
  """
  use BlogitWeb.Web, :controller

  plug BlogitWeb.Plugs.Locales
  plug BlogitWeb.Plugs.DefaultAssigns, blog: &__MODULE__.blog/1

  @doc """
  The only action of the controller. The index action lists all the available
  posts in the blog as RSS feed XML.

  Uses the current locale, so for path like `/en/feed` it will return the
  English posts feed and for `/bg/feed` the Bulgarian one. If the path is
  just `/feed` it will return the posts feed for the default language of
  `Blogit` (`Blogit.Settings.default_language()`).
  """
  def index(conn, _params) do
    posts = Repo.all(Blogit.Models.Post.Meta, 1000, 1, conn.assigns[:locale])
    posts_url = post_url(conn, :index)
    posts_path = post_path(conn, :index)

    posts = posts |> Enum.map(fn post ->
      preview = post.preview |> String.replace(posts_path, posts_url)
      Map.put(post, :preview, preview)
    end)

    conn
    |> put_layout(:none)
    |> put_resp_content_type("application/xml")
    |> render("index.xml", items: posts)
  end

  @doc """
  Retrieves the configuration of the blog using the locale assigned to the
  connection.
  """
  def blog(conn) do
    Repo.get(Blogit.Models.Configuration, conn.assigns[:locale])
  end
end
