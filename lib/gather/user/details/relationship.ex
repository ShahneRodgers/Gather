defmodule Gather.User.Details.Relationship do
  use Ecto.Schema
  import Ecto.Changeset

  alias Gather.Accounts.User

  @primary_key false
  schema "relationships" do
    field :name, :string, primary_key: true
    field :type, :string, primary_key: true
    belongs_to :user, User, primary_key: true

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
