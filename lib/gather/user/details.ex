defmodule Gather.User.Details do
  @moduledoc """
  The User.Details context.
  """

  import Ecto.Query, warn: false
  alias Gather.Repo

  alias Gather.User.Details.{Language, Relationship}

  @doc """
  Returns the list of languages spoken by a given user.
  """
  def get_languages_for_user(user) do
    Repo.all(from l in Language,
    where: l.user_id == ^user.id,
    select: l.language)
  end

  @doc """
  Returns the list of relatives of a given user.
  """
  def get_relations_for_user(user) do
    Repo.all(from r in Relationship,
    where: r.user_id == ^user.id,
    select: r)
  end

  @doc """
  Loads all the associations for a given user.
  """
  def load_user_details(user) do
    Repo.preload(user, :languages)
    |> Repo.preload(:relationships)
  end

  @doc """
  Creates a language.

  ## Examples

      iex> create_language(%{field: value})
      {:ok, %Language{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_language(attrs \\ %{}) do
    IO.puts("Creating language")
    IO.inspect(attrs)
    %Language{}
    |> Language.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a relationship.

  ## Examples

      iex> create_relationship(%{field: value})
      {:ok, %Relationship{}}

      iex> create_relationship(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_relationship(attrs \\ %{}) do
    %Relationship{}
    |> Relationship.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a Language.

  ## Examples

      iex> delete_language(language)
      {:ok, %Language{}}

      iex> delete_language(language)
      {:error, %Ecto.Changeset{}}

  """
  def delete_language(%Language{} = language) do
    Repo.delete(language)
  end

  @doc """
  Deletes a Relationship.

  ## Examples

      iex> delete_relationship(relationship)
      {:ok, %Relationship{}}

      iex> delete_language(relationship)
      {:error, %Ecto.Changeset{}}

  """
  def delete_relationship(%Relationship{} = relationship) do
    Repo.delete(relationship)
  end
end
