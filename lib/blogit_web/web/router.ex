defmodule BlogitWeb.Web.Router do
  use BlogitWeb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BlogitWeb.Plugs.Locales
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/feed", BlogitWeb.Web do
    get "/", FeedController, :index
  end

  scope "/:locale/feed", BlogitWeb.Web do
    get "/", FeedController, :index
  end

  scope "/", BlogitWeb.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/posts", PostController, :index
    get "/posts/:name", PostController, :show
  end

  scope "/:locale", BlogitWeb.Web do
    pipe_through :browser

    get "/", PageController, :index

    get "/posts", PostController, :index
    get "/posts/:name", PostController, :show
  end
end
