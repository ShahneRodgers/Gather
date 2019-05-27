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
