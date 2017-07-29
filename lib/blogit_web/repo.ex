defmodule BlogitWeb.Repo do
  @moduledoc """
  A collection of functions, which use the `Blogit` public interface to
  provide access to the blog data.

  It mirrors the Repo modules for Ecto powered Phoenix projects.
  """

  require BlogitWeb.Gettext

  @type locale :: String.t

  @type post :: Blogit.Models.Post.t
  @type post_meta :: Blogit.Models.Post.Meta.t
  @type configuration :: Blogit.Models.Configuration.t

  @doc """
  Retrieves all the posts for the given `locale` from the `Blogit`
  implementation in the form of `Blogit.Models.Post.Meta` structures.

  The `per_page` and `page` parameters are used for paging.
  """
  @spec all(Blogit.Models.Post.Meta, pos_integer, pos_integer, locale) ::
  [post_meta]
  def all(Blogit.Models.Post.Meta, per_page, page, locale) do
    all_posts(per_page, page, locale)
  end

  @doc """
  Retrieves a list with the configurations of the blog for the given `locale`.
  The list is always with only one element, a `Blogit.Models.Configuration`
  structure.
  """
  @spec all(Blogit.Models.Configuration, locale) :: [configuration]
  def all(Blogit.Models.Configuration, locale) do
    [get(Blogit.Models.Configuration, locale)]
  end

  @doc """
  Retrieves a single `Blogit.Models.Post` by its `id` - its name for the given
  `locale`.

  Returns {:ok, post} if the post exist in the `Blogit` store for posts for the
  given `locale` and {:error, message}, if it doesn't exist or there is other
  problem retrieving it.
  """
  @spec get(Blogit.Models.Post, atom, locale) :: post
  def get(Blogit.Models.Post, id, locale) do
    backend().post_by_name(String.to_atom(id), language: locale)
  end

  @doc """
  Retrieves the configuration of the blog for the given `locale`.
  """
  @spec get(Blogit.Models.Configuration, locale) :: configuration
  def get(Blogit.Models.Configuration, locale) do
    backend().configuration(language: locale)
  end

  @doc """
  Retrieves all the posts as `Blogit.Models.Post.Meta` for the given `locale`,
  filtered by the given `params` map.

  This `params` map supports zero or more of the following key-values:
  * "author" - Used to filter posts by their `.meta.author` field.
  * "category" - Used to filter posts by their `.meta.category` field.
  * "tags" - Used to filter posts by their `.meta.tags` field.
    The value for this key should a string of comma separated tags.
  * "year" - Used to filter posts by their `.meta.year` field.
  * "month" - Used to filter posts by their `.meta.month` field.
  * "q" - A query to filter posts by their content or title. Supports text in
    double quotes in order to search for phrases.

  The `per_page` and `page` arguments are used for paging.
  """
  @type filters :: %{String.t => Blogit.Logic.Search.search_value}
  @spec all_by(
    Blogit.Models.Post.Meta, pos_integer, pos_integer, filters, locale
  ) :: [post_meta]
  def all_by(Blogit.Models.Post.Meta, per_page, page, params, locale) do
    params =
      if BlogitWeb.Gettext.gettext("uncategorized") == params["category"] do
        %{params | "category" => nil}
      else
        params
      end

    is_search =
      Map.has_key?(params, "search") && Map.has_key?(params["search"], "q")
    params = if is_search do
               Map.merge(params, %{"q" => params["search"]["q"]})
             else
               params
             end

    backend().filter_posts(
      params, from: from(page, per_page), size: per_page, language: locale
    )
  end

  ###########
  # Private #
  ###########

  defp all_posts(per_page, page, locale) do
    backend().list_posts(
      from: from(page, per_page), size: per_page, language: locale
    )
  end

  defp from(0, _), do: 0
  defp from(1, _), do: 0
  defp from(n, per_page), do: (n - 1) * per_page

  defp backend do
    Application.get_env(:blogit_web, :backend_implementation, Blogit)
  end
end
