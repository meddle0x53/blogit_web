defmodule BlogitWeb.Web.PostController do
  @moduledoc """
  A controller module serving the requests for the post stream of the blog and
  for the individual posts.

  Supports listing, filtering and searching of posts as well as viewing
  individual posts and their meta data.

  Always puts in the assigns of the connection the last N posts,
  the posts-by-dates statistics and the pinned posts.

  Renders HTML views.
  """
  use BlogitWeb.Web, :controller

  plug :put_layout, "post.html"
  plug BlogitWeb.Plugs.DefaultAssigns, blog: &__MODULE__.blog/1
  plug :last_posts
  plug :pinned_posts
  plug :posts_by_dates

  @doc """
  The index action handles two types of requests.
  1. Requests for all the post previews sorted from the newest to the oldest,
  which supports the `page` and `per_page` request parameters so they could
  be paged.
  2. Request for a set of post previews, filtered by some criteria, which can
  be paged using the same two request parameters.

  This action supports localized paths like `/bg/posts`, so only the post
  stream for the given `locale` path parameter is returned.

  The request parameters for filtering posts could be one or more of:
  * `author` - Used to filter posts by their author.
  * `category` - Used to filter posts by their category. Could be the word
  returned by `BlogitWeb.Web.Gettext.gettext("uncategorized")` for the given
  `locale` and it will filter the uncategorized posts.
  * `tags` - Used to filter posts by their tags.
    The value for this parameter should be a string of comma separated tags.
  * `year` - Used to filter posts by the year they were published.
  * `month` - Used to filter posts by the month they were published.
  * `q` - A query to filter posts by their content or title. Supports text in
    double quotes in order to search for phrases.

  This action assigns the latest posts, the pinned posts, the configuration of
  the blog and the posts-by-month-of-year statistics to the connection.
  """
  def index(conn, params) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "4")
    parameters = Map.drop(params, ~w(page per_page locale))
    locale = conn.assigns[:locale]

    type = Blogit.Models.Post.Meta
    posts = case map_size(parameters) do
      0 -> Repo.all(type, per_page, page, locale)
      _ -> Repo.all_by(type, per_page, page, parameters, locale)
    end
    render_posts(conn, posts)
  end

  @doc """
  The show post action returns a full blog post representation.

  The post is identified by its uniq name.

  This action assigns the latest posts, the pinned posts, the configuration of
  the blog and the posts-by-month-of-year statistics to the connection.
  """
  def show(conn, %{"name" => name}) do
    render_post(conn, Repo.get(Blogit.Models.Post, name, conn.assigns[:locale]))
  end

  @doc """
  Retrieves the configuration of the blog using the locale assigned to the
  connection.
  """
  def blog(conn) do
    Repo.get(Blogit.Models.Configuration, conn.assigns[:locale])
  end

  ###########
  # Private #
  ###########

  defp render_posts(conn, posts), do: render conn, "index.html", posts: posts

  defp render_post(conn, {:error, _}) do
    conn
    |> put_status(:not_found)
    |> render("404.html")
  end

  defp render_post(conn, {:ok, post}) do
    render(
      conn, "show.html", post: post
    )
  end

  defp last_posts(conn, _params) do
    last_posts = Repo.all(Blogit.Models.Post.Meta, 8, 1, conn.assigns[:locale])
    assign(conn, :last_posts, last_posts)
  end

  defp pinned_posts(conn, _params) do
    assign(conn, :pinned_posts, Repo.list_pinned_posts(conn.assigns[:locale]))
  end

  defp posts_by_dates(conn, _params) do
    assign(conn, :posts_by_dates, Repo.posts_by_dates(conn.assigns[:locale]))
  end
end
