defmodule Gather.User.Details.Votes do
  use Ecto.Schema
  import Ecto.Changeset

  schema "votes" do
    field :up, :boolean

    belongs_to(:user, Gather.Accounts.User)
    belongs_to(:resource, Gather.Resources.Resource)
  end

  @doc false
  def changeset(votes, attrs) do
    votes
    |> cast(attrs, [:user_id, :resource_id])
    |> validate_required([:user_id, :resource_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:resource_id)
  end
end
