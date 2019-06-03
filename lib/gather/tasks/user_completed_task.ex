defmodule Gather.Tasks.UserCompletedTask do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "user_completed_task" do
    belongs_to(:subtask, Gather.Tasks.Subtask, primary_key: true)
    belongs_to(:user, Gather.Accounts.User, primary_key: true)
  end

  @doc false
  def changeset(user_completed_task, attrs) do
    user_completed_task
    |> cast(attrs, [:subtask_id, :user_id])
    |> validate_required([:subtask_id, :user_id])
  end
end
