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

    timestamps()
  end

  def changeset(%{password_hash: hash} = user, attrs) when not is_nil(hash) do
    cast(user, attrs, [:name, :email, :password, :arrival, :region, :nickname])
  end

  @doc false
  def changeset(%{password: password}=user, attrs) do
    user
    |> cast(attrs, [:name, :email, :arrival, :region, :nickname, :is_leader])
    |> validate_required([:name])
    |> put_pass_hash(password)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :arrival, :region, :nickname, :is_leader])
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true} = changeset, password) when not is_nil(password) do
    change(changeset, Argon2.add_hash(password))
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
