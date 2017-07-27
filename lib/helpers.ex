defmodule BlogitWeb.Helpers do
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
