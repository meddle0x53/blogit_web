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

  def current_locale do
    Gettext.get_locale(BlogitWeb.Gettext)
  end

  defmacro localized_path(conn, resource, endpoint) do
    quote do
      name = String.to_atom("#{unquote(resource)}_path")
      path = apply(BlogitWeb.Router.Helpers, name, [unquote(conn), unquote(endpoint)])

      if current_locale() != Blogit.Settings.default_language() do
        "/#{current_locale()}#{path}"
      else
        path
      end
    end
  end

  defmacro __using__(_params) do
    funcs =
      :functions
      |> BlogitWeb.Router.Helpers.module_info()
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
          link = apply(BlogitWeb.Router.Helpers, unquote(fname), unquote(args))
          locale = Gettext.get_locale(BlogitWeb.Gettext)

          if locale != Blogit.Settings.default_language() do
            path_func = String.to_atom(
              String.replace(unquote(to_string(fname)), "url", "path")
            )
            path = apply(BlogitWeb.Router.Helpers, path_func, unquote(args))
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

  defp create_args(_, 0), do: []
  defp create_args(fn_mdl, arg_cnt) do
    Enum.map(1..arg_cnt, &(Macro.var (:"arg#{&1}"), fn_mdl))
  end
end
