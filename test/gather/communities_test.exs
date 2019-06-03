defmodule Gather.CommunitiesTest do
  use Gather.DataCase

  alias Gather.Communities

  describe "communities" do
    alias Gather.Communities.Community

    @valid_attrs %{link: "some link", location: "some location", name: "some name", summary: "some summary"}
    @update_attrs %{link: "some updated link", location: "some updated location", name: "some updated name", summary: "some updated summary"}
    @invalid_attrs %{link: nil, location: nil, name: nil, summary: nil}

    def community_fixture(attrs \\ %{}) do
      {:ok, community} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Communities.create_community()

      community
    end

    test "list_communities/0 returns all communities" do
      community = community_fixture()
      assert Communities.list_communities() == [community]
    end

    test "get_community!/1 returns the community with given id" do
      community = community_fixture()
      assert Communities.get_community!(community.id) == community
    end

    test "create_community/1 with valid data creates a community" do
      assert {:ok, %Community{} = community} = Communities.create_community(@valid_attrs)
      assert community.link == "some link"
      assert community.location == "some location"
      assert community.name == "some name"
      assert community.summary == "some summary"
    end

    test "create_community/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Communities.create_community(@invalid_attrs)
    end

    test "update_community/2 with valid data updates the community" do
      community = community_fixture()
      assert {:ok, %Community{} = community} = Communities.update_community(community, @update_attrs)
      assert community.link == "some updated link"
      assert community.location == "some updated location"
      assert community.name == "some updated name"
      assert community.summary == "some updated summary"
    end

    test "update_community/2 with invalid data returns error changeset" do
      community = community_fixture()
      assert {:error, %Ecto.Changeset{}} = Communities.update_community(community, @invalid_attrs)
      assert community == Communities.get_community!(community.id)
    end

    test "delete_community/1 deletes the community" do
      community = community_fixture()
      assert {:ok, %Community{}} = Communities.delete_community(community)
      assert_raise Ecto.NoResultsError, fn -> Communities.get_community!(community.id) end
    end

    test "change_community/1 returns a community changeset" do
      community = community_fixture()
      assert %Ecto.Changeset{} = Communities.change_community(community)
    end
  end
end
