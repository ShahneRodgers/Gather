defmodule GatherWeb.ResourcesController do
  use GatherWeb, :controller

  alias Gather.Resources
  alias Gather.Accounts
  alias Gather.Resources.{Resource, Categories}

  require Logger

  @categories [:housing, :work, :education, :transport, :health, :law, :service_providers, :communities, :other]

  def index(conn, _params) do
    resources = Resources.list_resources()
    authors = Enum.map(resources, fn r -> r.user_id end)
              |> Accounts.find_users()
              |> Enum.map(fn u -> if is_nil(u.nickname) or u.nickname == "", do: u.name, else: u.nickname end)
              |> Enum.sort()
    languages = Enum.map(resources, fn r -> r.language end)
                |> Enum.sort()
    formats = Enum.map(resources, fn r -> r.format end)
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
        if Map.get(resource_params, "category") do
          Resources.create_resource_category(Map.put(resource_params, "resource_id", resource.id))
        end

        redirect(conn, to: Routes.resources_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def search(conn, _params) do
    redirect(conn, to: Routes.resources_path(conn, :index))
  end

  def category(conn, %{"category" => category}) do
    resources = Resources.get_by_category(category)
    render(conn, "category.html", resources: resources)
  end
end
