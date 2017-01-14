defmodule BlogitWeb.PageController do
  use BlogitWeb.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
