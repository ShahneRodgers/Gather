defmodule Gather.User.Representatives do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "community_representatives" do
    field :about, :string
    field :email, :string
    field :phone, :string

    belongs_to(:user, Gather.Accounts.User, primary_key: true)
  end

  @doc false
  def changeset(representatives, attrs) do
    representatives
    |> cast(attrs, [:email, :phone, :about, :user_id])
    |> validate_required([:email, :about, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
