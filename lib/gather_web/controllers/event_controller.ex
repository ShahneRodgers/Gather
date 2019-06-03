defmodule GatherWeb.EventController do
  use GatherWeb, :controller

  alias Gather.Events
  alias Gather.Events.Event

  def index(conn, %{"region" => "all"}) do
    Events.list_events()
    |> render_index(conn)
  end

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    Events.list_events(user.region)
    |> render_index(conn, user.region)
  end

  defp render_index(events, conn, region \\ nil) do
    render(conn, "index.html", events: events, region: region)
  end

  def new(conn, params) do
    date = case Map.get(params, "date") <> " 17:00:00"  |> NaiveDateTime.from_iso8601() do
      {:ok, date} -> date
      _ -> NaiveDateTime.utc_now()
    end
    changeset = Events.change_event(%Event{ time: date })
    render(conn, "new.html", changeset: changeset, regions: Gather.Regions.regions(), date: date)
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"event" => event_params}) do
    user = Guardian.Plug.current_resource(conn)
    case Events.create_event(Map.put(event_params, "author", user.id)) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, regions: Gather.Regions.regions())
    end
  end

  def show(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    render(conn, "show.html", event: event)
  end

  def edit(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    changeset = Events.change_event(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Events.get_event!(id)

    case Events.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    {:ok, _event} = Events.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: Routes.event_path(conn, :index))
  end
end
