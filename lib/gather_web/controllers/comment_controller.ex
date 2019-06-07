defmodule GatherWeb.CommentController do
  use GatherWeb, :controller

  alias Gather.Tasks
  alias Gather.Resources

  def new(conn, %{"task_id" => task_id}) do
    create_comment(conn, task_id, "task_id", &Tasks.add_comment/1)
  end

  def new(conn, %{"resource_id" => resource_id}) do
    create_comment(conn, resource_id, "resource_id", &Resources.add_comment/1)
  end

  def update(conn, %{"task_id" => _, "comment_id" => comment_id}) do
    update_comment(conn, comment_id, &Tasks.get_comment/1, &Tasks.update_comment/2)
  end

  def update(conn, %{"resources_id" => _, "comment_id" => comment_id}) do
    update_comment(conn, comment_id, &Resources.get_comment/1, &Resources.update_comment/2)
  end

  def delete(conn, %{"task_id" => _, "comment_id" => comment_id}) do
    delete_comment(conn, comment_id, &Tasks.get_comment/1, &Tasks.delete_comment/1)
  end

  def delete(conn, %{"resources_id" => _, "comment_id" => comment_id}) do
    delete_comment(conn, comment_id, &Resources.get_comment/1, &Resources.delete_comment/1)
  end

  defp create_comment(req_conn, id, id_name, add_comment) do
    {:ok, body, conn} = Plug.Conn.read_body(req_conn)
    user = Guardian.Plug.current_resource(conn)

    %{id_name => id, "comment" => body, "user_id" => user.id}
    |> add_comment.()

    send_resp(conn, 200, "")
  end

  defp update_comment(req_conn, id, get_comment, update_comment) do
    {:ok, body, conn} = Plug.Conn.read_body(req_conn)
    user = Guardian.Plug.current_resource(conn)

    comment = get_comment.(id)
    if body == "" or is_nil(comment) or comment.user_id != user.id do
      send_resp(conn, 404, "")
    else
      update_comment.(comment, %{"comment" => body})
      send_resp(conn, 200, "")
    end
  end

  defp delete_comment(conn, id,  get_comment, delete_comment) do
    user = Guardian.Plug.current_resource(conn)

    comment = get_comment.(id)
    if is_nil(comment) or comment.user_id != user.id do
      send_resp(conn, 404, "")
    else
      delete_comment.(comment)
      send_resp(conn, 200, "")
    end
  end
end
