defmodule Gather.Accounts.ErrorHandler do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  require Logger
  require GatherWeb.Gettext

  def auth_error(conn, {type, reason}, _opts) do
    Logger.info("Authentication error of type: #{type} with reason #{reason}")

    put_flash(conn, :info, GatherWeb.Gettext.gettext("You must log in"))
    |> redirect(to: "/login")
    |> halt()
  end
end
