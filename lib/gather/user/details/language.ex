defmodule Gather.User.Details.Language do
  use Ecto.Schema
  import Ecto.Changeset

  alias Gather.Accounts.User

  schema "languages" do
    field :language, :string
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(languages, attrs) do
    languages
    |> cast(attrs, [:language, :user_id])
    |> validate_required([:language, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
