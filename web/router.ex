defmodule BlogitWeb.Router do
  use BlogitWeb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BlogitWeb.Plugs.Locales
    plug Turbolinks
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/feed", BlogitWeb do
    get "/", FeedController, :index
  end

  scope "/:locale/feed", BlogitWeb do
    get "/", FeedController, :index
  end

  scope "/", BlogitWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/posts", PostController, :index
    get "/posts/:name", PostController, :show
  end

  scope "/:locale", BlogitWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/posts", PostController, :index
    get "/posts/:name", PostController, :show
  end
end
