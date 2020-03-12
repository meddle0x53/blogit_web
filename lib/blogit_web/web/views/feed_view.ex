defmodule BlogitWeb.Web.FeedView do
  use BlogitWeb.Web, :view

  def date_format(post) do
    {:ok, date} =
      post.created_at
      |> Calendar.NaiveDateTime.to_date_time_utc()
      |> Calendar.Strftime.strftime("%a, %d %b %Y %H:%M:%S %z")

    date
  end
end
