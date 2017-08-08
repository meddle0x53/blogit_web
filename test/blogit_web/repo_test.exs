defmodule BlogitWeb.RepoTest do
  use ExUnit.Case

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

      assert posts |> Enum.map(&(&1.name)) == ~w[публикация1 публикация2]
    end

    test "returns empty list of posts, if there are no posts to be found " <>
    "for the given arguments" do
      posts = BlogitWeb.Repo.all(Blogit.Models.Post.Meta, 2, 4, "en")

      assert posts |> Enum.map(&(&1.name)) == []
    end

    test "returns the configuration of the blog as list of one element if " <>
    "it is called with `Blogit.Models.Configuration`" do
      configurations = BlogitWeb.Repo.all(Blogit.Models.Configuration, "en")
      assert length(configurations) == 1

      configuration = List.first(configurations)
      assert configuration.title == "My blog"
    end

    test "passes the given `locale` to the backend if " <>
    "it is called with `Blogit.Models.Configuration`" do
      configurations = BlogitWeb.Repo.all(Blogit.Models.Configuration, "bg")
      assert length(configurations) == 1

      configuration = List.first(configurations)
      assert configuration.title == "Моят блог"
    end
  end

  describe "get" do
    test "returns a post by its name if invoked with `Blogit.Models.Post`, " <>
    "the result is in the form the backend returns it" do
      {:ok, post} = BlogitWeb.Repo.get(Blogit.Models.Post, "post2", "en")

      assert post.name == "post2"
    end

    test "returns a post by its name if invoked with `Blogit.Models.Post`, " <>
    "the result is in the form the backend returns it; Not found case" do
      {:error, msg} = BlogitWeb.Repo.get(Blogit.Models.Post, "post20", "en")

      assert msg == "post not found"
    end

    test "returns a post by its name if invoked with `Blogit.Models.Post`, " <>
    "the result is in the form the backend returns it; The given `lacale` " <>
    "is passed to the backend" do
      {:ok, post} = BlogitWeb.Repo.get(Blogit.Models.Post, "публикация2", "bg")

      assert post.name == "публикация2"
    end

    test "returns the configuration of the blog if it is called with " <>
    "`Blogit.Models.Configuration`" do
      configuration = BlogitWeb.Repo.get(Blogit.Models.Configuration, "en")

      assert configuration.title == "My blog"
    end

    test "passes the given `locale` to the backend if it is called with " <>
    "`Blogit.Models.Configuration`" do
      configuration = BlogitWeb.Repo.get(Blogit.Models.Configuration, "bg")

      assert configuration.title == "Моят блог"
    end
  end

  describe "all_by" do
    test "uses the backend `filter_posts` functions to filter posts" do
      posts = BlogitWeb.Repo.all_by(
        Blogit.Models.Post.Meta, 2, 1, %{"author" => "meddle"}, "en"
      )

      assert posts |> Enum.map(&(&1.name)) == ~w[post1]
    end

    test ~S[if the filtering is done by category and the localized value] <>
    ~S[of `uncategorized` is passed, it passes the category criteria as ] <>
    ~S[`"category" => nil`] do
      Gettext.put_locale(BlogitWeb.Gettext, "bg")
      posts = BlogitWeb.Repo.all_by(
        Blogit.Models.Post.Meta, 2, 1, %{"category" => "некатегоризирано"}, "bg"
      )
      Gettext.put_locale(BlogitWeb.Gettext, "en")

      assert posts |> Enum.map(&(&1.name)) == ~w[публикация2]
    end
  end
end
