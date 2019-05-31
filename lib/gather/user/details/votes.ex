defmodule Gather.User.Details.Votes do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "votes" do
    field :up, :boolean

    belongs_to :user, Gather.Accounts.User, primary_key: true
    belongs_to :resource, Gather.Resources.Resource, primary_key: true
  end

  @doc false
  def changeset(votes, attrs) do
    votes
    |> cast(attrs, [:user_id, :resource_id, :up])
    |> validate_required([:user_id, :resource_id, :up])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:resource_id)
    |> unique_constraint(:resource_id, name: :votes_resource_id_user_id_index)
  end
end
