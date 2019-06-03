defmodule Gather.EventsTest do
  use Gather.DataCase

  alias Gather.Events

  describe "events" do
    alias Gather.Events.Event

    @valid_attrs %{address: "some address", link: "some link", name: "some name", region: "some region", summary: "some summary", time: ~N[2010-04-17 14:00:00]}
    @update_attrs %{address: "some updated address", link: "some updated link", name: "some updated name", region: "some updated region", summary: "some updated summary", time: ~N[2011-05-18 15:01:01]}
    @invalid_attrs %{address: nil, link: nil, name: nil, region: nil, summary: nil, time: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Events.create_event(@valid_attrs)
      assert event.address == "some address"
      assert event.link == "some link"
      assert event.name == "some name"
      assert event.region == "some region"
      assert event.summary == "some summary"
      assert event.time == ~N[2010-04-17 14:00:00]
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, %Event{} = event} = Events.update_event(event, @update_attrs)
      assert event.address == "some updated address"
      assert event.link == "some updated link"
      assert event.name == "some updated name"
      assert event.region == "some updated region"
      assert event.summary == "some updated summary"
      assert event.time == ~N[2011-05-18 15:01:01]
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end
end
