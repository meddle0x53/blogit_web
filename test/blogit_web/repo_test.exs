defmodule BlogitWeb.RepoTest do
  use ExUnit.Case

  defmodule DummyBlogit do
    @meta %{
      "en" => [
        %Blogit.Models.Post.Meta{
          name: "post1"
        },
        %Blogit.Models.Post.Meta{
          name: "post2"
        },
        %Blogit.Models.Post.Meta{
          name: "post3"
        },
        %Blogit.Models.Post.Meta{
          name: "post4"
        }
      ],
      "bg" => [
        %Blogit.Models.Post.Meta{
          name: "публикация1"
        }
      ]
    }

    def list_posts(options \\ []) do
      from = Keyword.get(options, :from, 0)
      size = Keyword.get(options, :size, 5)
      language = Keyword.get(options, :language, "en")

      (@meta[language] || []) |> Enum.drop(from)|> Enum.take(size)
    end

  end

  setup_all do
    Application.put_env(:blogit_web, :backend_implementation, DummyBlogit)
    :ok
  end

  describe "all" do
    test "returns all the post meta structures for the specified options if " <>
    "the first argument is passed as `Blogit.Models.Post.Meta`" do
      posts = BlogitWeb.Repo.all(Blogit.Models.Post.Meta, 2, 1, "en")

      assert posts |> Enum.map(&(&1.name)) == ~w[post1 post2]
    end

    test "supports paging for models of type `Blogit.Models.Post.Meta`" do
      posts = BlogitWeb.Repo.all(Blogit.Models.Post.Meta, 2, 2, "en")

      assert posts |> Enum.map(&(&1.name)) == ~w[post3 post4]
    end

    test "passes the given `locale` to the backend to retrieve list of " <>
    "posts from the right locale set" do
      posts = BlogitWeb.Repo.all(Blogit.Models.Post.Meta, 2, 1, "bg")

      assert posts |> Enum.map(&(&1.name)) == ~w[публикация1]
    end

    test "returns empty list of posts, if there are no posts to be found " <>
    "for the given arguments" do
      posts = BlogitWeb.Repo.all(Blogit.Models.Post.Meta, 2, 4, "en")

      assert posts |> Enum.map(&(&1.name)) == []
    end
  end
end
