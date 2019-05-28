defmodule Gather.User.Details.Relationship do
  use Ecto.Schema
  import Ecto.Changeset

  alias Gather.Accounts.User

  schema "relationships" do
    field :name, :string
    field :type, :string
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(relationships, attrs) do
    relationships
    |> cast(attrs, [:name, :type, :user_id])
    |> validate_required([:name, :type, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
