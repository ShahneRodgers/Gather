defmodule Gather.Resources.Resource do
  use Ecto.Schema
  import Ecto.Changeset

  schema "resources" do
    field :format, :string
    field :link, :string
    field :title, :string
    field :summary, :string
    field :user_id, :id

    has_many(:categories, Gather.Resources.Categories)
    has_many(:comments, Gather.Resources.Comments)
    has_many(:languages, Gather.Resources.ResourceLanguages)
    has_many(:votes, Gather.User.Details.Votes)

    timestamps()
  end

  @doc false
  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:link, :title, :summary, :format, :user_id])
    |> validate_required([:link, :title, :format, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
