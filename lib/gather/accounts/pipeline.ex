defmodule Gather.Accounts.MaybeAuthenticatedPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :gather,
    error_handler: Gather.Accounts.ErrorHandler,
    module: Gather.Accounts.Guardian

  @claims %{iss: "gather"}

  plug(Guardian.Plug.VerifySession, claims: @claims)

  plug(Guardian.Plug.VerifyHeader, claims: @claims, realm: "Bearer")

  plug(Guardian.Plug.LoadResource, allow_blank: true)
end

defmodule Gather.Accounts.AuthenticatedPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :gather,
    error_handler: Gather.Accounts.ErrorHandler,
    module: Gather.Accounts.Guardian

  plug(Gather.Accounts.MaybeAuthenticatedPipeline)

  plug(Guardian.Plug.EnsureAuthenticated)

  plug(Guardian.Plug.LoadResource, allow_blank: false)
end

defmodule Gather.Accounts.EnsureProfileCreated do
  import Plug.Conn
  import GatherWeb.Gettext

  def init(_) do
  end

  def call(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    if not is_nil(user) and is_nil(user.region) do
      Phoenix.Controller.put_flash(conn, :info, gettext("You must set your location"))
      |> Phoenix.Controller.redirect(to: GatherWeb.Router.Helpers.user_path(conn, :profile))
      |> halt()
    else
      conn
    end
  end
end
