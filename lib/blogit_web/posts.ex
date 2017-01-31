defmodule BlogitWeb.Posts do
  require BlogitWeb.Gettext

  @supported_params ~w(author category)

  def filter_by_params(params) do
    filters = for {key, val} <- params, into: %{} do
      {String.to_atom(key), val}
    end

    filters = filter_category(filters)
    tagless_filters = Map.delete filters, :tags

    filter_tags(
      filters, BlogitWeb.Repo.all_by(Blogit.Post, tagless_filters, [:meta])
    )
  end

  defp filter_category(filters = %{category: "uncategorized"}) do
    %{filters | category: nil}
  end

  defp filter_category(filters = %{category: category}) do
    case BlogitWeb.Gettext.gettext("uncategorized") == category do
      true -> %{filters | category: nil}
      false -> filters
    end
  end

  defp filter_category(filters), do: filters

  defp filter_tags(%{tags: tags}, posts) do
    cond do
      String.match?(tags, ~r/^\w+\s*(,\s*\w+\s*)*$/) ->
        filter_by_tags(tags, posts)
      true -> posts
    end
  end

  defp filter_tags(_, posts), do: posts

  defp filter_by_tags(tags, posts) do
    tag_set = tags |> String.split(",", trim: true) |> Enum.into(HashSet.new)

    Enum.filter(posts, fn (post) ->
      Set.subset?(tag_set, post.meta.tags |> Enum.into(HashSet.new))
    end)
  end
end
