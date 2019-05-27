defmodule GatherWeb.PageController do
  use GatherWeb, :controller

  def index(%Plug.Conn{params: %{"id" => id}} = conn, _params) do
    redirect(conn, to: Routes.user_path(conn, :profile))
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
