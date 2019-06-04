defmodule GatherWeb.UserController do
  use GatherWeb, :controller

  alias Gather.Accounts
  alias Gather.Accounts.User
  alias Gather.User.Details

  require Logger

  def index(conn, _params) do
    users = Accounts.list_users()

    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        Logger.info(fn ->
          "#{inspect(user)} was created"
        end)

        redirect(conn, to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def profile(conn, _) do
    user = Guardian.Plug.current_resource(conn)
           |> Details.load_user_details()
    changeset = Accounts.change_user(user)
    render(conn, "profile.html", user: user, changeset: changeset, regions: Gather.Regions.regions())
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)
    case Accounts.update_user(user, user_params) do
      {:ok, _} -> redirect(conn, to: Routes.user_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} -> render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def update_details(conn, %{"user" => user_params}) do
    user = Guardian.Plug.current_resource(conn)
          |> Details.load_user_details()

    with {:ok, user} <- Accounts.update_user(user, user_params),
          {:ok, _} <- update_languages(user, user_params),
          {:ok, _} <- update_relationships(user, user_params)
    do
      redirect(conn, to: Routes.user_path(conn, :profile))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "profile.html", user: user, changeset: changeset, regions: Gather.Regions.regions())
      _ -> render(conn, "profile.html", user: user, changeset: Accounts.change_user(user), regions: Gather.Regions.regions())
    end
  end

  defp update_languages(user, %{"languages" => language_params}=user_params) do
    # FIXME: this should probably be done more efficiently
    Enum.map(user.languages, &Details.delete_language/1)
    if Enum.all?(Map.values(language_params), &store_language?/1) do
      {:ok, nil}
    else
      {:error, user_params}
    end
  end

  defp update_languages(_user, _params) do
    {:ok, nil}
  end

  defp store_language?(language) do
    if language["language"] != "" do
      case Details.create_language(language) do
        {:ok, _} -> true
        _ -> false
      end
    else
      true
    end
  end

  defp update_relationships(user, %{"relationships" => relationship_params}=user_params) do
    # FIXME: this should probably be done more efficiently
    Enum.map(user.relationships, &Details.delete_relationship/1)
    if Enum.all?(Map.values(relationship_params), &store_relationship?/1) do
      IO.puts("Updated relationships")
      {:ok, nil}
    else
      {:error, user_params}
    end
  end

  defp update_relationships(_user, _params) do
    {:ok, nil}
  end

  defp store_relationship?(relationship) do
    if relationship["type"] != "" or relationship["name"] != "" do
      case Details.create_relationship(relationship) do
        {:ok, _} -> true
        _ -> false
      end
    else
      true
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    Logger.info(fn ->
      current_user = Guardian.Plug.current_resource(conn)

      "#{user.name} (#{user.id}) was deleted by #{current_user.name} (#{
        current_user.id
      })"
    end)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end

  def become_rep(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    changeset =
      case Gather.Users.get_representative(user.id) do
        nil -> %Gather.User.Representatives{}
        rep -> rep
      end
      |> Gather.Users.change_representative()
    render(conn, "rep.html", changeset: changeset)
  end

  def create_rep(conn, %{"representatives" => params}) do
    user = Guardian.Plug.current_resource(conn)
    Gather.Users.delete_representative(user.id)
    case Gather.Users.create_representative(Map.put(params, "user_id", user.id)) do
      {:ok, _} -> redirect(conn, to: Routes.community_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "rep.html", changeset: changeset)
    end
  end

  def remove_rep(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    Gather.Users.delete_representative(user.id)
    redirect(conn, to: Routes.community_path(conn, :index))
  end
end
