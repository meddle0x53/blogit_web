defmodule BlogitWeb.Repo do
  def all(Blogit.Post, limit \\ nil) do
    all_posts(limit)
  end

  def all(_, _), do: []

  def get(Blogit.Post, id) do
    Blogit.post_by_name(String.to_atom(id))
  end

  def get(module, id) do
    Enum.find all(module), fn entry -> entry.id == id end
  end

  def get_by(module, params) do
    Enum.find all(module), fn entry ->
      Enum.all?(params, fn {key, val} -> Map.get(entry, key) == val end)
    end
  end

  defp all_posts(nil), do: Blogit.list_posts
  defp all_posts(n) when is_integer(n), do: Blogit.list_posts |> Enum.take(n)
end
