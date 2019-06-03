defmodule GatherWeb.PageController do
  use GatherWeb, :controller

  def index(conn, _params) do
    if Guardian.Plug.current_resource(conn) do
      redirect(conn, to: Routes.user_path(conn, :profile))
    else
      render(conn, "index.html")
    end
  end

  def contact(conn, _params) do
    render(conn, "contact.html", regions: Gather.Regions.regions())
  end
end
