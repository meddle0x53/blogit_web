defmodule BlogitWeb.PageController do
  use BlogitWeb.Web, :controller

  def index(conn, _params) do
    redirect(conn, to: post_path(conn, :index))
  end
end
