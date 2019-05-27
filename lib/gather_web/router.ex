defmodule GatherWeb.Router do
  use GatherWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authenticate do
    plug(:browser)
    plug(Gather.Accounts.AuthenticatedPipeline)
  end

  pipeline :maybe_authenticate do
    plug(:browser)
    plug(Gather.Accounts.MaybeAuthenticatedPipeline)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GatherWeb do
    pipe_through :maybe_authenticate

    get "/", PageController, :index
  end

  scope "/", GatherWeb do
    pipe_through :browser

    get "/start", TaskController, :index
    get "/login", AuthenticationController, :login
    post "/login", AuthenticationController, :login
    resources "/user", UserController
  end

  scope "/", GatherWeb do
    pipe_through :authenticate

    get "/profile", UserController, :profile
  end

  # Other scopes may use custom stacks.
  # scope "/api", GatherWeb do
  #   pipe_through :api
  # end
end
