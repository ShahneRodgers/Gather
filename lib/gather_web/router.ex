defmodule GatherWeb.Router do
  use GatherWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug GatherWeb.Languages.LanguagesPlug
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
    pipe_through :browser

    get "/login", AuthenticationController, :login
    post "/login", AuthenticationController, :login
  end

  scope "/", GatherWeb do
    pipe_through :maybe_authenticate

    get "/", PageController, :index
    get "/logout", AuthenticationController, :logout
    get "/contact", PageController, :contact
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
    post "/tasks/comment/:task_id", TaskController, :comment
    get "/tasks/complete/:subtask_id", TaskController, :complete

    post "/resources/search", ResourcesController, :search
    resources "/resources", ResourcesController, only: [:index, :new, :create]

    resources "/events", EventController

    resources "/communities", CommunityController

    get "/resources/category", ResourcesController, :category
    get "/resources/votes/:resource_id/:type", ResourcesController, :vote
    post "/resources/comment/:resource_id", ResourcesController, :comment

    get "/users/representative", UserController, :become_rep
    post "/users/representative", UserController, :create_rep
    get "/users/representative/remove", UserController, :remove_rep
  end

  scope "/admin", GatherWeb do
    pipe_through :browser

    resources "/user", UserController
    get "/tasks/new", TaskController, :new
    post "/tasks/create", TaskController, :create
    get "/subtasks/new", TaskController, :new_subtask
    post "/subtasks/create", TaskController, :create_subtask
    get "/subtasks/resource", TaskController, :new_resource
    post "/subtasks/resource", TaskController, :create_resource
  end

  # Other scopes may use custom stacks.
  # scope "/api", GatherWeb do
  #   pipe_through :api
  # end
end
