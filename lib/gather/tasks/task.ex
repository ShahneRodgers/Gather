defmodule Gather.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :completed, :boolean, default: false
    field :task, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:task, :completed, :user_id])
    |> validate_required([:task, :completed, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
