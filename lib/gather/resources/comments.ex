defmodule Gather.Resources.Comments do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :comment, :string

    belongs_to(:resource, Gather.Resources.Resource)
    belongs_to(:user, Gather.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(comments, attrs) do
    comments
    |> cast(attrs, [:comment, :resource_id, :user_id])
    |> validate_required([:comment, :resource_id, :user_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:resource_id)
  end
end
