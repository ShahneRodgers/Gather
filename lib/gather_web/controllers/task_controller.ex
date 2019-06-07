defmodule GatherWeb.TaskController do
  use GatherWeb, :controller

  alias Gather.Tasks

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    tasks = Tasks.list_tasks(user.region)
            |> Enum.sort_by(fn t -> t.order end)
    user_completed_tasks = Tasks.list_user_completed_subtask_ids(user)

    users = Enum.flat_map(tasks, fn t -> Enum.flat_map(t.subtasks, fn s -> Enum.map(s.resources, fn r -> r.user_id end) end) end)
              |> Gather.Accounts.find_users()
              |> Map.new(fn user -> {user.id, Gather.Accounts.User.get_display_name(user)} end)
    render(conn, "index.html", tasks: tasks, users: users, completed: user_completed_tasks)
  end

  def new(conn, _) do
    changeset = Tasks.change_task(%Tasks.Task{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    case Tasks.create_task(task_params) do
      {:ok, task} ->
        if Map.get(task_params, "subtasks") do
          add_associations(task_params["subtasks"], task.id, &Tasks.create_subtask/1)
        end

        redirect(conn, to: Routes.task_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp add_associations(params, task_id, func) do
    # FIXME: this should probably be done more efficiently
    Enum.map(Map.values(params), fn param -> if param != "", do: func.(Map.put(param, "task_id", task_id)) end)
    :ok
  end

  def new_subtask(conn, %Ecto.Changeset{}=changeset) do
    user = Guardian.Plug.current_resource(conn)

    render(conn, "new_subtask.html", changeset: changeset, tasks: Tasks.list_tasks(user.region))
  end

  def new_subtask(conn, _) do
    changeset = Tasks.change_subtask(%Tasks.Subtask{})
    new_subtask(conn, changeset)
  end

  def create_subtask(conn, %{"subtask" => subtask_params}) do
    case Tasks.create_subtask(subtask_params) do
      {:ok, _} -> redirect(conn, to: Routes.task_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} -> new_subtask(conn, changeset)
    end
  end

  def new_resource(conn, %Ecto.Changeset{}=changeset) do
    resources = Gather.Resources.list_resources()
    render(conn, "new_subtask_resource.html", changeset: changeset, subtasks: Tasks.list_subtasks(), resources: resources)
  end

  def new_resource(conn, _) do
    changeset = Tasks.change_resource(%Tasks.Resources{})
    new_resource(conn, changeset)
  end

  def create_resource(conn, %{"resources" => resource_params}) do
    case Tasks.create_subtask_resource(resource_params) do
      {:ok, _} -> redirect(conn, to: Routes.task_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} -> new_resource(conn, changeset)
    end
  end

  def complete(conn, %{"subtask_id" => subtask_id}) do
    user = Guardian.Plug.current_resource(conn)

    params = %{"user_id" => user.id, "subtask_id" => subtask_id}
    if Tasks.user_completed_task? params do
      Tasks.delete_completed(params)
    else
      Tasks.add_completed(params)
    end

    send_resp(conn, 200, "")
  end
end
