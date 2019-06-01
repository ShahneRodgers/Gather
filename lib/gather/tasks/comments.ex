defmodule Gather.Tasks.Comments do
  use Ecto.Schema
  import Ecto.Changeset

  schema "task_comment" do
    field :comment, :string

    timestamps()

    belongs_to(:task, Gather.Tasks.Task)
    belongs_to(:user, Gather.Accounts.User)
  end

  @doc false
  def changeset(comments, attrs) do
    comments
    |> cast(attrs, [:comment, :task_id, :resource_id])
    |> validate_required([:comment, :task_id, :resource_id])
    |> foreign_key_constraint(:task_id)
    |> foreign_key_constraint(:resource_id)
  end
end
