defmodule Gather.Tasks.Subtask do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subtask" do
    field :title, :string

    belongs_to(:task, Gather.Tasks.Task)

    has_many(:task_resources, Gather.Tasks.Resources)
    has_many(:resources, through: [:task_resources, :resource])
  end

  @doc false
  def changeset(subtask, attrs) do
    subtask
    |> cast(attrs, [:title, :task_id])
    |> validate_required([:title, :task_id])
    |> foreign_key_constraint(:task_id)
    |> unique_constraint(:title)
  end
end
