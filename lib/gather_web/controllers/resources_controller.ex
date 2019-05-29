defmodule GatherWeb.ResourcesController do
  use GatherWeb, :controller

  alias Gather.Resources
  alias Gather.Accounts

  @categories [:housing, :work, :education, :transport, :health, :law, :service_providers, :communities, :other]

  def index(conn, _params) do
    resources = Resources.list_resources()
    authors = Enum.map(resources, fn r -> r.user_id end)
              |> Accounts.find_users()
              |> Enum.map(fn u -> if u.nickname and u.nickname != "", do: u.nickname, else: u.name end)
              |> Enum.sort()
    languages = Enum.map(resources, fn r -> r.language end)
                |> Enum.sort()
    formats = Enum.map(resources, fn r -> r.format end)
              |> Enum.sort()

    render(conn, "index.html", resources: resources, categories: @categories, authors: authors, languages: languages, formats: formats)
  end

  def search(conn, _params) do
    redirect(conn, to: Routes.resources_path(conn, :index))
  end

  def category(conn, %{"category" => category}) do
    resources = Resources.get_by_category(category)
    render(conn, "category.html", resources: resources)
  end
end
