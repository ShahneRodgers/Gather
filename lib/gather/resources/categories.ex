defmodule Gather.Resources.Categories do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "categories" do
    field :category, :string, primary_key: true

    belongs_to :resource, Gather.Resources.Resource, primary_key: true

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
