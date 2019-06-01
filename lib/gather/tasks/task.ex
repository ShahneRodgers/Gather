defmodule Gather.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :title, :string
    field :order, :integer

    has_many(:subtasks, Gather.Tasks.Subtask)
    has_many(:comments, Gather.Tasks.Comments)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :order])
    |> validate_required([:title, :order])
    |> unique_constraint(:order)
  end
end
