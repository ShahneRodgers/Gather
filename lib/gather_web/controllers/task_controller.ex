defmodule GatherWeb.TaskController do
  use GatherWeb, :controller

  alias Gather.Tasks

  def index(conn, _params) do
    tasks = Tasks.list_tasks()
    render(conn, "index.html", tasks: tasks)
  end
end
