defmodule Gather.Communities.Community do
  use Ecto.Schema
  import Ecto.Changeset

  schema "communities" do
    field :link, :string
    field :region, :string
    field :name, :string
    field :summary, :string

    field :creator, :id
  end

  @doc false
  def changeset(community, attrs) do
    community
    |> cast(attrs, [:name, :region, :summary, :link, :creator])
    |> validate_required([:name, :region, :summary, :link, :creator])
    |> validate_change(:region, &Gather.Regions.validate_region/2)
    |> foreign_key_constraint(:creator)
  end
end
