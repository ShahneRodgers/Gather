defmodule Gather.User.Details.Language do
  use Ecto.Schema
  import Ecto.Changeset

  alias Gather.Accounts.User

  @primary_key false
  schema "languages" do
    field :language, :string, primary_key: true
    belongs_to :user, User, primary_key: true

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
