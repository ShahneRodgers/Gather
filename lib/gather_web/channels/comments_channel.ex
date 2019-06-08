defmodule GatherWeb.CommentsChannel do
  use Phoenix.Channel

  def join("comments", _message, socket) do
    {:ok, socket}
  end

end
