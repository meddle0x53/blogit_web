defmodule BlogitWeb.PostController do
  use BlogitWeb.Web, :controller

  plug :put_layout, "post.html"
  plug DefaultAssigns, blog: &__MODULE__.blog/1
  plug :last_posts
  plug :pinned_posts
  plug :posts_by_dates

  def index(conn, params) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "2")
    parameters = Map.drop(params, ~w(page per_page))
    locale = conn.assigns[:locale]

    posts = case map_size(parameters) do
      0 -> Repo.all(Blogit.Post, per_page, page, locale)
      _ -> Repo.all_by(Blogit.Post, per_page, page, parameters, locale)
    end
    render_posts(conn, posts)
  end

  def show(conn, %{"name" => name}) do
    render_post(conn, Repo.get(Blogit.Post, name, conn.assigns[:locale]))
  end

  def blog(conn), do: Repo.get(Blogit.Configuration, nil, conn.assigns[:locale])

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
    last_posts = Repo.all(Blogit.Post, 10, 1, conn.assigns[:locale])
    assign(conn, :last_posts, last_posts)
  end

  defp pinned_posts(conn, _params) do
    locale = conn.assigns[:locale]
    assign(conn, :pinned_posts, Blogit.list_pinned(language: locale))
  end

  defp posts_by_dates(conn, _params) do
    locale = conn.assigns[:locale]
    assign(conn, :posts_by_dates, Blogit.posts_by_dates(language: locale))
  end
end
