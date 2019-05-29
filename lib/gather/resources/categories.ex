defmodule Gather.Resources.Categories do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :category, :string
    field :resource_id, :id

    timestamps()
  end

  @doc false
  def changeset(categories, attrs) do
    categories
    |> cast(attrs, [:category, :resource_id])
    |> validate_required([:category, :resource_id])
    |> foreign_key_constraint(:resource_id)
  end
end
