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
    |> cast(attrs, [:category, :user_id])
    |> validate_required([:category, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
