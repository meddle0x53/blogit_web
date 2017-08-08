defmodule DummyBlogit do
  @meta %{
    "en" => [
      %Blogit.Models.Post.Meta{
        name: "post1", author: "meddle", category: "Test",
        preview: "<h1>First Bost</h1>",
        created_at: ~N[2017-05-21 08:46:50], pinned: false,
        title: "Post One"
      },
      %Blogit.Models.Post.Meta{
        name: "post2", author: "slavi", preview: "<h1>Second Bost</h1>",
        created_at: ~N[2017-07-25 18:36:33], pinned: true,
        title: "Post Two", tags: "stuff"
      },
      %Blogit.Models.Post.Meta{
        name: "post3", author: "valo",
        preview: ~s[<h1>Third Bost</h1><a href="/posts/post1">A link</a>],
        created_at: ~N[2017-04-26 16:26:26], pinned: false,
        title: "Post Three", tags: []
      },
      %Blogit.Models.Post.Meta{
        name: "post4", author: "andi", preview: "<h1>Fourth Bost</h1>",
        created_at: ~N[2017-03-13 21:55:26], pinned: false,
        title: "Post Four", year: 2017, month: 3
      }
    ],
    "bg" => [
      %Blogit.Models.Post.Meta{
        name: "публикация1", category: "Test",
        preview: "<h1>Първа Бубликация</h1>",
        created_at: ~N[2017-05-21 08:46:50], pinned: false, tags: []
      },
      %Blogit.Models.Post.Meta{
        name: "публикация2",
        preview: ~s(<h1>Втора Бубликация</h1><a href="/bg/posts/so">A link</a>),
        created_at: ~N[2017-06-15 15:18:39], pinned: false,
      }
    ]
  }

  @configuration %{
    "en" => %Blogit.Models.Configuration{
      title: "My blog"
    },
    "bg" => %Blogit.Models.Configuration{
      title: "Моят блог"
    },
  }

  def list_posts(options \\ []) do
    from = Keyword.get(options, :from, 0)
    size = Keyword.get(options, :size, 5)
    language = Keyword.get(options, :language, "en")

    (@meta[language] || []) |> Enum.drop(from)|> Enum.take(size)
  end

  def configuration(options \\ []) do
    @configuration[Keyword.get(options, :language, "en")]
  end

  def post_by_name(name, options \\ []) do
    language = Keyword.get(options, :language, "en")
    post = (@meta[language] || []) |> Enum.find(&(&1.name == to_string(name)))

    if is_nil(post) do
      {:error, "post not found"}
    else
      {
        :ok,
        %Blogit.Models.Post{
          meta: post, name: post.name, html: post.preview, raw: post.preview
        }
      }
    end
  end

  def filter_posts(params, options \\ []) do
    params =
      if params["q"] do
        updated = Map.put(params, "title", params["q"])
        Map.delete(updated, "q")
      else
        params
      end

    params =
      if params["year"] do
        Map.put(params, "year", String.to_integer(params["year"]))
      else
        params
      end

    params =
      if params["month"] do
        Map.put(params, "month", String.to_integer(params["month"]))
      else
        params
      end

    options |> list_posts() |> Enum.filter(fn post ->
      Enum.all?(params, fn {key, val} ->
        Map.fetch!(post, String.to_atom(key)) == val
      end)
    end)
  end

  def list_pinned(options \\ []) do
    list_posts(options)
    |> Enum.filter(&(&1.pinned))
    |> Enum.map(&({&1.name, &1.title}))
  end

  def posts_by_dates(options \\ []) do
    list_posts(Keyword.put_new(options, :size, 100))
    |> Enum.map(fn meta -> %{meta: meta} end)
    |> Blogit.Models.Post.collect_by_year_and_month()
  end
end
