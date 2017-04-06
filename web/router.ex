defmodule BlogitWeb.Router do
  use BlogitWeb.Web, :router

  pipeline :browser do
    plug Beaker.Integrations.Phoenix
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BlogitWeb do
    pipe_through :browser # Use the default browser stack

    get "/imgs", ImagesController, :show

    get "/", PageController, :index

    get "/posts", PostController, :index
    get "/posts/:name", PostController, :show
  end

  scope "/feed", BlogitWeb do
    get "/", FeedController, :index
  end

  forward "/beaker", Beaker.Web

  # Other scopes may use custom stacks.
  # scope "/api", BlogitWeb do
  #   pipe_through :api
  # end
end
