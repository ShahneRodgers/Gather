defmodule GatherWeb.AuthenticationController do
  use GatherWeb, :controller

  alias Gather.Accounts

  require Logger


  def login(conn, %{"username" => username, "password" => password}) do
    matching_user = Accounts.find_by_name(username)

    Argon2.check_pass(matching_user, password)
    |> password_response(conn, username, matching_user)
  end

  def login(conn, _) do
    render(conn, :login)
  end

  defp password_response({:ok, _}, conn, _, matching_user) do
    Accounts.Guardian.Plug.sign_in(conn, matching_user)
    |> redirect(to: Routes.user_path(conn, :profile))
  end

  defp password_response({:error, _}, conn, username, _) do
    fail_login(conn, username)
  end

  def logout(conn, _) do
    Accounts.Guardian.Plug.sign_out(conn)
    |> redirect(to: Routes.page_path(conn, :login))
  end

  defp fail_login(conn, username) do
    Logger.info(fn -> "An attempt to login as #{username} failed" end)

    fail_login(conn)
  end

  defp fail_login(conn) do
    put_flash(conn, :warning, "Incorrect username or password")
    |> login(nil)
  end
end
