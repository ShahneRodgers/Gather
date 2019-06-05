defmodule Gather.Resources.Resource do
  use Ecto.Schema
  import Ecto.Changeset

  schema "resources" do
    field :format, :string
    field :link, :string
    field :title, :string
    field :summary, :string
    field :user_id, :id
    field :region, :string

    has_many(:categories, Gather.Resources.Categories)
    has_many(:comments, Gather.Resources.Comments)
    has_many(:languages, Gather.Resources.ResourceLanguages)
    has_many(:votes, Gather.User.Details.Votes)

    timestamps()
  end

  def score(resource) do
    Enum.reduce(resource.votes, 0, fn v, acc -> if v.up, do: acc + 1, else: acc - 1 end)
  end

  @doc false
  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:link, :title, :summary, :format, :user_id, :region])
    |> validate_required([:link, :title, :format, :user_id])
    |> validate_change(:region, &Gather.Regions.validate_region/2)
    |> foreign_key_constraint(:user_id)
  end
end
