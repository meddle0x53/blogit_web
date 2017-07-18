defmodule BlogitWeb.Repo do
  require BlogitWeb.Gettext

  def all(Blogit.Post, per_page, page, locale) do
    all_posts(per_page, page, locale)
  end

  def all(Blogit.Configuration, _, locale) do
    [get(Blogit.Configuration, nil, locale)]
  end

  def all(_, _), do: []

  def get(Blogit.Post, id, locale) do
    Blogit.post_by_name(String.to_atom(id), language: locale)
  end

  def get(Blogit.Configuration, _, locale) do
    Blogit.configuration(language: locale)
  end

  def get(module, id, locale) do
    Enum.find(all(module, 1000, 1, locale), fn entry -> entry.id == id end)
  end

  def get_by(module, params, locale) do
    Enum.find(all(module, 1000, 1, locale), fn entry ->
      Enum.all?(params, fn {key, val} -> Map.get(entry, key) == val end)
    end)
  end

  def all_by(Blogit.Post, per_page, page, params, locale) do
    params =
      case BlogitWeb.Gettext.gettext("uncategorized") == params["category"] do
        true -> %{params | "category" => nil}
        false -> params
      end
    params = case Map.has_key?(params, "search") && Map.has_key?(params["search"], "q") do
      true -> Map.merge(params, %{"q" => params["search"]["q"]})
      false -> params
    end

    from_post = from(page, per_page)
    Blogit.filter_posts(params, from_post, per_page, language: locale)
    |> published
  end

  defp all_posts(per_page, page, locale) do
    Blogit.list_posts(from(page, per_page), per_page, language: locale)
    |> published
  end

  defp published(posts) do
    posts |> Enum.filter(fn post -> post.meta.published end)
  end

  defp from(0, _), do: 0
  defp from(1, _), do: 0
  defp from(n, per_page), do: (n - 1) * per_page
end
