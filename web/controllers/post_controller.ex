defmodule BlogitWeb.PostController do
  use BlogitWeb.Web, :controller

  plug :put_layout, "post.html"
  plug DefaultAssigns, blog: &__MODULE__.blog/0
  plug :last_posts
  plug :pinned_posts
  plug :posts_by_dates

  def index(conn, params) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "2")
    parameters = Map.drop(params, ~w(page per_page))

    posts = case map_size(parameters) do
      0 -> Repo.all(Blogit.Post, per_page, page)
      _ -> Repo.all_by(Blogit.Post, per_page, page, parameters)
    end
    render_posts(conn, posts)
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
    assign(conn, :last_posts, Repo.all(Blogit.Post, 7, 1))
  end

  defp pinned_posts(conn, _params) do
    assign(conn, :pinned_posts, Blogit.list_pinned())
  end

  defp posts_by_dates(conn, _params) do
    assign(conn, :posts_by_dates, Blogit.posts_by_dates())
  end

  defp set_locale(conn, _) do
    lang = conn.params["lang"]

    language =
      if lang != nil && Enum.member?(Blogit.Settings.languages(), lang) do
        lang
      else
        Blogit.Settings.default_language()
      end

    Gettext.put_locale(BlogitWeb.Gettext, language)
    conn
  end
end
