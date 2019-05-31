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

  pipeline :ensure_profile do
    plug(Gather.Accounts.EnsureProfileCreated)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GatherWeb do
    pipe_through :maybe_authenticate

    get "/", PageController, :index
    get "/logout", AuthenticationController, :logout
    get "/contact", PageController, :contact
  end

  scope "/", GatherWeb do
    pipe_through :browser

    get "/login", AuthenticationController, :login
    post "/login", AuthenticationController, :login
    resources "/user", UserController
  end

  scope "/", GatherWeb do
    pipe_through :authenticate

    get "/profile", UserController, :profile
    put "/profile", UserController, :update_details
  end

  scope "/", GatherWeb do
    pipe_through :authenticate
    pipe_through :ensure_profile

    get "/start", TaskController, :index

    post "/resources/search", ResourcesController, :search
    resources "/resources", ResourcesController, only: [:index, :new, :create]

    get "/resources/category", ResourcesController, :category
    get "/resources/votes/:resource_id/:type", ResourcesController, :vote
    post "/resources/comment/:resource_id", ResourcesController, :comment
  end

  # Other scopes may use custom stacks.
  # scope "/api", GatherWeb do
  #   pipe_through :api
  # end
end
