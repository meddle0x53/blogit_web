defmodule BlogitWeb.Helpers do
  @moduledoc """
  Contains a set of macros and functions helping with localization.

  Contains a function for retrieving the currently set locale from
  `Gettext` : `BlogitWeb.Helpers.current_locale/0`.

  Can be included in the `BlogitWeb.Web.controller/0` and `BlogitWeb.Web.view/0`
  function bodies using `use BlogitWeb.Helpers`, which will cause the path/url
  helper functions called in views and controllers to respect the locale,
  returned by `BlogitWeb.Helpers.current_locale/0`.

  For example the call `post_path(conn, :index)` will return `"/posts"` if the
  current locale is the default one, but if it is not the default and is for
  example `bg`, the call will return `"/bg/posts"`. Same will be with
  post_url -> `"protocol://domain:post/<locale>/posts"`.

  With this all the links in the current page, if the current locale is for
  example `bg`, will point to `bg` pages.

  The static paths/urls are not affected.
  """

  @doc """
  Returns the current locale used by `Gettext`.

  ## Examples

      iex> Gettext.put_locale(BlogitWeb.Web.Gettext, "es")
      iex> BlogitWeb.Helpers.current_locale()
      "es"
  """
  @spec current_locale() :: String.t
  def current_locale do
    Gettext.get_locale(BlogitWeb.Web.Gettext)
  end

  @doc """
  Creates a localized path for a given `resource`.

  If this macro is invoked like this:
  ```
  BlogitWeb.Helpers.localized_path(conn, "post", :index)
  ```
  and the `BlogitWeb.Helpers.current_locale/0` returns `"de"`, which is not
  the default locale, the path returned will be `"/de/posts"`. If the
  current locale is the default one, the path will be `"/posts"`.

  This macro is invoked for all the `*_path` and `*_url` functions, using the
  resource part of their names, of the module in which `use BlogitWeb.Helpers`
  is called, except `static_path` and `static_url`.

  If the using module contains a function called `post_path`,
  the `localized_path` macro will be invoked like this
  ```
  BlogitWeb.Helpers.localized_path(conn, "post", :index)
  ```
  when it is called and its result will be used instead the original result.
  """
  defmacro localized_path(conn, resource, endpoint) do
    quote do
      name = String.to_atom("#{unquote(resource)}_path")
      arguments = [unquote(conn), unquote(endpoint)]
      path = apply(BlogitWeb.Web.Router.Helpers, name, arguments)
      locale = BlogitWeb.Helpers.current_locale()

      if locale != Blogit.Settings.default_language() do
        "/#{locale}#{path}"
      else
        path
      end
    end
  end

  @doc false
  defmacro __using__(_params) do
    funcs =
      :functions
      |> BlogitWeb.Web.Router.Helpers.module_info()
      |> Enum.filter(fn {fname, _} ->  fname != :static_path end)
      |> Enum.filter(fn {fname, _} ->  fname != :static_url end)
      |> Enum.filter(fn {fname, _} ->
        name = to_string(fname)
        String.ends_with?(name, "path") || String.ends_with?(name, "url")
      end)

    funcs
    |> Enum.map(fn {fname, arity} ->
      args = create_args(__MODULE__, arity)
      quote do
        def unquote(fname)(unquote_splicing(args)) do
          link = apply(BlogitWeb.Web.Router.Helpers, unquote(fname), unquote(args))
          locale = BlogitWeb.Helpers.current_locale()

          if locale != Blogit.Settings.default_language() do
            path_func = String.to_atom(
              String.replace(unquote(to_string(fname)), "url", "path")
            )
            path = apply(BlogitWeb.Web.Router.Helpers, path_func, unquote(args))
            String.replace(
              link, path, "/#{locale}#{path}"
            )
          else
            link
          end
        end
      end
    end)
  end

  ###########
  # Private #
  ###########

  defp create_args(_, 0), do: []
  defp create_args(fn_mdl, arg_cnt) do
    Enum.map(1..arg_cnt, &(Macro.var (:"arg#{&1}"), fn_mdl))
  end
end
