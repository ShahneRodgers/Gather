defmodule Gather.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :address, :string
    field :link, :string
    field :name, :string
    field :region, :string
    field :summary, :string
    field :time, :naive_datetime
    field :author, :id
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :time, :region, :address, :link, :summary, :author])
    |> validate_required([:name, :time, :region, :address, :link, :summary, :author])
    |> validate_change(:region, &Gather.Regions.validate_region/2)
    |> foreign_key_constraint(:author)
  end
end
