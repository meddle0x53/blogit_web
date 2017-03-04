defmodule BlogitWeb.Repo do
  require BlogitWeb.Gettext

  def all(Blogit.Post, per_page, page), do: all_posts(per_page, page)
  def all(Blogit.Configuration, _), do: [get(Blogit.Configuration, nil)]
  def all(_, _), do: []

  def get(Blogit.Post, id), do: Blogit.post_by_name(String.to_atom(id))
  def get(Blogit.Configuration, _), do: Blogit.configuration
  def get(module, id) do
    Enum.find all(module, 1000, 1), fn entry -> entry.id == id end
  end

  def get_by(module, params) do
    Enum.find all(module, 1000, 1), fn entry ->
      Enum.all?(params, fn {key, val} -> Map.get(entry, key) == val end)
    end
  end

  def all_by(Blogit.Post, per_page, page, params) do
    params =
      case BlogitWeb.Gettext.gettext("uncategorized") == params["category"] do
        true -> %{params | "category" => nil}
        false -> params
      end
    params = case Map.has_key?(params, "search") && Map.has_key?(params["search"], "q") do
      true -> Map.merge(params, %{"q" => params["search"]["q"]})
      false -> params
    end
    Blogit.filter_posts(params, from(page, per_page), per_page) |> published
  end

  defp all_posts(per_page, page) do
    Blogit.list_posts(from(page, per_page), per_page) |> published
  end

  defp published(posts) do
    posts |> Enum.filter(fn post -> post.meta.published end)
  end

  defp from(0, _), do: 0
  defp from(1, _), do: 0
  defp from(n, per_page), do: (n - 1) * per_page
end
