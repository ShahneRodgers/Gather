 defmodule Gather.Users do
  import Ecto.Query, warn: false

  alias Gather.Repo
  alias Gather.User.Representatives

  @doc """
    Returns the list of representatives for a region.

    ## Examples

        iex> list_representatives(region)
        [%User{}, ...]

  """
  def list_representatives(region) do
    Repo.all(from rep in Representatives,
            left_join: user in Gather.Accounts.User, on: user.id == rep.user_id,
            where: is_nil(user.region) or user.region == ^region,
            preload: [user: user])
  end

  @doc """
    Creates a representative.

  ## Examples

      iex> create_representatives(%{field: value})
      {:ok, %Representative{}}

      iex> create_representative(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_representative(attrs \\ %{}) do
    %Representatives{}
    |> Representatives.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking representative changes.

  ## Examples

      iex> change_representative(rep)
      %Ecto.Changeset{source: %Representatives{}}

  """
  def change_representative(%Representatives{} = rep) do
    Representatives.changeset(rep, %{})
  end

  @doc """
  Gets representative details for the given user id or nil if the user is not a representative
  """
  def get_representative(user_id) do
    Repo.get_by(Representatives, user_id: user_id)
  end

  @doc """
  Removes a user from the list of representatives
  """
  def delete_representative(user_id) do
    Repo.delete_all(from r in Representatives,
                    where: r.user_id == ^user_id)
  end
end
