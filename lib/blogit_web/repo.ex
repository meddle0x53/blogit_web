defmodule BlogitWeb.Repo do
  def all(Blogit.Post) do
    Blogit.list_posts
  end

  def all(_), do: []

  def get(Blogit.Post, id) do
    Blogit.post_by_name(id)
  end

  def get(module, id) do
    Enum.find all(module), fn entry -> entry.id == id end
  end

  def get_by(module, params) do
    Enum.find all(module), fn entry ->
      Enum.all?(params, fn {key, val} -> Map.get(entry, key) == val end)
    end
  end
end
