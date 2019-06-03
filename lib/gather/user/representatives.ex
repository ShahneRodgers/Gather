defmodule Gather.User.Representatives do
  use Ecto.Schema
  import Ecto.Changeset

  schema "community_representatives" do
    field :about, :string
    field :email, :string
    field :phone, :string

    belongs_to(:user, Gather.Accounts.User)
  end

  @doc false
  def changeset(representatives, attrs) do
    representatives
    |> cast(attrs, [:email, :phone, :about, :user_id])
    |> validate_required([:email, :phone, :about, :user_id])
  end
end
