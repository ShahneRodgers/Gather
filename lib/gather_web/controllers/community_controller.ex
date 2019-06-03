defmodule GatherWeb.CommunityController do
  use GatherWeb, :controller

  alias Gather.Communities
  alias Gather.Communities.Community
  alias Gather.Users

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    communities = Communities.list_communities(user.region)
    representatives = Users.list_representatives(user.region)
    render(conn, "index.html", communities: communities, representatives: representatives, region: user.region)
  end

  def new(conn, _params) do
    changeset = Communities.change_community(%Community{})
    render(conn, "new.html", changeset: changeset, regions: Gather.Regions.regions())
  end

  def create(conn, %{"community" => community_params}) do
    user = Guardian.Plug.current_resource(conn)

    case Communities.create_community(Map.put(community_params, "creator", user.id)) do
      {:ok, community} ->
        conn
        |> put_flash(:info, "Community created successfully.")
        |> redirect(to: Routes.community_path(conn, :show, community))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, regions: Gather.Regions.regions())
    end
  end

  def show(conn, %{"id" => id}) do
    community = Communities.get_community!(id)
    render(conn, "show.html", community: community)
  end

  def edit(conn, %{"id" => id}) do
    community = Communities.get_community!(id)
    changeset = Communities.change_community(community)
    render(conn, "edit.html", community: community, changeset: changeset)
  end

  def update(conn, %{"id" => id, "community" => community_params}) do
    community = Communities.get_community!(id)

    case Communities.update_community(community, community_params) do
      {:ok, community} ->
        conn
        |> put_flash(:info, "Community updated successfully.")
        |> redirect(to: Routes.community_path(conn, :show, community))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", community: community, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    community = Communities.get_community!(id)
    {:ok, _community} = Communities.delete_community(community)

    conn
    |> put_flash(:info, "Community deleted successfully.")
    |> redirect(to: Routes.community_path(conn, :index))
  end
end
