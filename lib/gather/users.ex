 defmodule Gather.Users do

  import Ecto.Query, warn: false
  alias Gather.Repo

  @doc """
    Returns the list of representatives for a region.

    ## Examples

        iex> list_representatives(region)
        [%User{}, ...]

    """
    def list_representatives(region) do
      Repo.all(from rep in Gather.User.Representatives,
              left_join: user in Gather.Accounts.User, on: user.id == rep.user_id,
              where: is_nil(user.region) or user.region == ^region)
    end
end
