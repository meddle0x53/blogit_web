defmodule BlogitWeb.ImagesController do
  use BlogitWeb.Web, :controller

  def show(conn, %{"path" => path}) do
    conn
    |> put_resp_content_type("image/jpeg")
    |> send_file(200, path)
  end
end
