defmodule Gather.Tasks.Resources do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "task_resource" do
    belongs_to(:subtask, Gather.Tasks.Subtask, primary_key: true)
    belongs_to(:resource, Gather.Resources.Resource, primary_key: true)
  end

  @doc false
  def changeset(resources, attrs) do
    resources
    |> cast(attrs, [:subtask_id, :resource_id])
    |> validate_required([:subtask_id, :resource_id])
    |> foreign_key_constraint(:subtask_id)
    |> foreign_key_constraint(:resource_id)
  end
end
