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

    timestamps()
  end

  @doc false
  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:link, :summary, :language, :format, :score, :user_id])
    |> validate_required([:link, :language, :format, :user_id])
  end
end
