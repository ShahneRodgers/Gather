defmodule GatherWeb.CommunityControllerTest do
  use GatherWeb.ConnCase

  alias Gather.Communities

  @create_attrs %{link: "some link", location: "some location", name: "some name", summary: "some summary"}
  @update_attrs %{link: "some updated link", location: "some updated location", name: "some updated name", summary: "some updated summary"}
  @invalid_attrs %{link: nil, location: nil, name: nil, summary: nil}

  def fixture(:community) do
    {:ok, community} = Communities.create_community(@create_attrs)
    community
  end

  describe "index" do
    test "lists all communities", %{conn: conn} do
      conn = get(conn, Routes.community_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Communities"
    end
  end

  describe "new community" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.community_path(conn, :new))
      assert html_response(conn, 200) =~ "New Community"
    end
  end

  describe "create community" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.community_path(conn, :create), community: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.community_path(conn, :show, id)

      conn = get(conn, Routes.community_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Community"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.community_path(conn, :create), community: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Community"
    end
  end

  describe "edit community" do
    setup [:create_community]

    test "renders form for editing chosen community", %{conn: conn, community: community} do
      conn = get(conn, Routes.community_path(conn, :edit, community))
      assert html_response(conn, 200) =~ "Edit Community"
    end
  end

  describe "update community" do
    setup [:create_community]

    test "redirects when data is valid", %{conn: conn, community: community} do
      conn = put(conn, Routes.community_path(conn, :update, community), community: @update_attrs)
      assert redirected_to(conn) == Routes.community_path(conn, :show, community)

      conn = get(conn, Routes.community_path(conn, :show, community))
      assert html_response(conn, 200) =~ "some updated link"
    end

    test "renders errors when data is invalid", %{conn: conn, community: community} do
      conn = put(conn, Routes.community_path(conn, :update, community), community: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Community"
    end
  end

  describe "delete community" do
    setup [:create_community]

    test "deletes chosen community", %{conn: conn, community: community} do
      conn = delete(conn, Routes.community_path(conn, :delete, community))
      assert redirected_to(conn) == Routes.community_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.community_path(conn, :show, community))
      end
    end
  end

  defp create_community(_) do
    community = fixture(:community)
    {:ok, community: community}
  end
end
