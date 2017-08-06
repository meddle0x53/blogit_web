defmodule BlogitWeb.PageController do
  @moduledoc """
  A controller module serving the requests to the root of the server's domain.

  It has only `index` action, which redirects to the `BlogitWeb.PostController`
  `index` action. In other words request to `/` is the same as request to
  `/posts`.
  """
  use BlogitWeb.Web, :controller

  @doc """
  The only action of the controller. It redirects to `post_path(conn, :index)`.
  """
  def index(conn, _params) do
    redirect(conn, to: post_path(conn, :index))
  end
end
