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
    plug(:put_user_token)
  end

  pipeline :maybe_authenticate do
    plug(:browser)
    plug(Gather.Accounts.MaybeAuthenticatedPipeline)
    plug(:put_user_token)
  end

  defp put_user_token(conn, _) do
    if current_user = Guardian.Plug.current_resource(conn) do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
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
    get "/tasks/complete/:subtask_id", TaskController, :complete
    post "/tasks/comment/:task_id", CommentController, :new, as: :task_comment
    post "/tasks/comment/:task_id/update/:comment_id", CommentController, :update, as: :task_comment
    get "/tasks/comment/:task_id/delete/:comment_id", CommentController, :delete, as: :task_comment

    post "/resources/search", ResourcesController, :search
    resources "/resources", ResourcesController, only: [:index, :new, :create]

    resources "/events", EventController

    resources "/communities", CommunityController

    get "/resources/category", ResourcesController, :category
    get "/resources/votes/:resource_id/:type", ResourcesController, :vote
    post "/resources/comment/:resource_id", CommentController, :new, as: :resource_comment
    post "/resources/comment/:resource_id/update/:comment_id", CommentController, :update, as: :resource_comment
    get "/resources/comment/:resource_id/delete/:comment_id", CommentController, :delete, as: :resource_comment

    get "/users/representative", UserController, :become_rep
    post "/users/representative", UserController, :create_rep
    get "/users/representative/remove", UserController, :remove_rep
  end

  scope "/admin", GatherWeb do
    pipe_through :maybe_authenticate # FIXME: ensure community leader eventually

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
