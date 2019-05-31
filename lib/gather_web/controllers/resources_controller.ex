defmodule GatherWeb.ResourcesController do
  use GatherWeb, :controller

  alias Gather.Resources
  alias Gather.Accounts
  alias Gather.Resources.Resource

  require Logger

  @categories [:housing, :work, :education, :transport, :health, :law, :service_providers, :communities, :other]

  def index(conn, _params) do
    resources = Resources.list_resources()
    authors = Enum.map(resources, fn r -> r.user_id end)
              |> Accounts.find_users()
              |> Enum.map(&Accounts.User.get_display_name/1)
              |> Enum.sort()
    languages = Enum.flat_map(resources, fn r -> Enum.map(r.languages, fn l -> l.language end) end)
                |> Enum.uniq()
                |> Enum.sort()
    formats = Enum.map(resources, fn r -> r.format end)
              |> Enum.uniq()
              |> Enum.sort()

    render(conn, "index.html", resources: resources, categories: @categories, authors: authors, languages: languages, formats: formats)
  end

  def new(conn, _params) do
    changeset = Resources.change_resource(%Resource{})
    render(conn, "new.html", changeset: changeset, categories: @categories)
  end

  def create(conn, %{"resource" => resource}) do
    user = Guardian.Plug.current_resource(conn)
    resource_params = Map.put(resource, "user_id", user.id)
    case Resources.create_resource(resource_params) do
      {:ok, resource} ->
        Logger.info(fn ->
          "#{inspect(resource)} was created by #{user.id}"
        end)
        # FIXME: atomic add?
        if Map.get(resource_params, "categories") do
          add_associations(resource_params["categories"], resource.id, &Resources.create_resource_category/1)
        end

        if (Map.get(resource_params, "languages")) do
          add_associations(resource_params["languages"], resource.id, &Resources.create_resource_language/1)
        end

        redirect(conn, to: Routes.resources_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, categories: @categories)
    end
  end

  defp add_associations(params, resource_id, func) do
    # FIXME: this should probably be done more efficiently
    Enum.map(Map.values(params), fn param -> if param != "", do: func.(Map.put(param, "resource_id", resource_id)) end)
    :ok
  end

  def search(conn, _params) do
    redirect(conn, to: Routes.resources_path(conn, :index))
  end

  def category(conn, %{"category" => category}) do
    resources = Resources.get_by_category(category)
                |> Enum.sort_by(fn r -> -Resource.score(r) end)
    users = Enum.flat_map(resources, fn r -> Enum.map(r.comments, fn c -> c.user_id end) end)
            |> Enum.concat(Enum.map(resources, fn r -> r.user_id end))
            |> Accounts.find_users()
            |> Map.new(fn user -> {user.id, Accounts.User.get_display_name(user)} end)

    render(conn, "resources.html", resources: resources, users: users)
  end

  def vote(conn, %{"resource_id" => resource_id, "type" => "up"}) do
    vote(conn, %{"resource_id" => resource_id, "up" => true})
  end

  def vote(conn, %{"resource_id" => resource_id, "type" => "down"}) do
    vote(conn, %{"resource_id" => resource_id, "up" => false})
  end

  def vote(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    case Resources.add_vote(Map.put(params, "user_id", user.id)) do
      {:ok, _} -> send_resp(conn, 200, "")
      _ -> send_resp(conn, 500, "")
    end
  end

  def comment(req_conn, %{"resource_id" => resource_id}) do
    {:ok, body, conn} = Plug.Conn.read_body(req_conn)
    user = Guardian.Plug.current_resource(conn)

    %{"resource_id" => resource_id, "comment" => body, "user_id" => user.id}
    |> Resources.add_comment()

    send_resp(conn, 200, "")
  end
end
