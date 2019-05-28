defmodule Gather.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :arrival, :date
    field :email, :string
    field :name, :string
    field :region, :string
    field :nickname, :string
    field :password_hash, :string
    field :is_leader, :boolean
    field :english_level, :integer
    field :english_school, :string

    has_many(:languages, Gather.User.Details.Language)
    has_many(:relationships, Gather.User.Details.Relationship)

    timestamps()
  end

  @doc false
  def changeset(user, %{"password" => password}=attrs) when password != "" do
    IO.puts("Updating password")
    IO.inspect(password)
    user
    |> cast(attrs, [:name, :email, :arrival, :region, :nickname, :is_leader, :english_level, :english_school])
    |> validate_required([:name])
    |> put_pass_hash(password)
  end

  @doc false
  def changeset(%{password_hash: hash} = user, attrs) when not is_nil(hash) do
    IO.puts("Existing hash")
    user
    |> cast(attrs, [:name, :email, :arrival, :region, :nickname, :is_leader, :english_level, :english_school])
    |> validate_required([:name, :email, :password_hash, :region])
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password_hash, :arrival, :region, :nickname, :is_leader, :english_level, :english_school])
    |> validate_required([:name, :email, :password_hash, :region])
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true} = changeset, password) when not is_nil(password) do
    changeset
    |> cast(Argon2.add_hash(password), [:password_hash])
  end

  defp put_pass_hash(changeset, _) do
    changeset
  end

  @doc """
  Gets a single user.

  Returns nil if the user does not exist.
  """
  def get_user(id) do
    Gather.Repo.get(User, id)
  end
end
