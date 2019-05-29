defmodule Gather.Resources.Resource do
  use Ecto.Schema
  import Ecto.Changeset

  schema "resources" do
    field :format, :string
    field :language, :string
    field :link, :string
    field :score, :integer
    field :summary, :string
    field :user_id, :id

    has_many(:categories, Gather.Resources.Categories)
    has_many(:comments, Gather.Resources.Comments)

    timestamps()
  end

  @doc false
  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:link, :summary, :language, :format, :score, :user_id])
    |> validate_required([:link, :language, :format, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
