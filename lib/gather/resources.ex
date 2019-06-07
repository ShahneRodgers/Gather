defmodule Gather.Resources do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias Gather.Repo

  alias Gather.Resources.{Resource, Categories, Comments, ResourceLanguages}
  alias Gather.User.Details.Votes

  @doc """
  Returns the list of resources.

  ## Examples

      iex> list_resources()
      [%Resource{}, ...]

  """
  def list_resources do
    Repo.all(from r in Resource,
            preload: [:languages])
  end

  @doc """
  Returns the list of resources that are relevant to the given region.

  ## Examples

      iex> list_resources(region)
      [%Resource{}, ...]

  """
  def list_resources(region) do
    Repo.all(from r in Resource,
            where: is_nil(r.region) or r.region == ^region,
            preload: [:languages])
  end

  def get_by_category(category, region) do
    Repo.all(from cat in Categories,
             where: cat.category == ^category,
             join: r in Resource, on: cat.resource_id == r.id,
             select: r)
      |> Repo.preload([:categories, :comments, :votes, :languages])
      |> Enum.filter(fn r -> is_nil(r.region) or r.region == region end)
  end

  @doc """
  Creates a resource.

  ## Examples

      iex> create_resource(%{field: value})
      {:ok, %Resource{}}

      iex> create_resource(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_resource(attrs \\ %{}) do
    %Resource{}
    |> Resource.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Assign a category to a resource.
  """
  def create_resource_category(attrs \\ %{}) do
    %Categories{}
    |> Categories.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Assign a language to a resource.
  """
  def create_resource_language(attrs \\ %{}) do
    %ResourceLanguages{}
    |> ResourceLanguages.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a resource.

  ## Examples

      iex> update_resource(resource, %{field: new_value})
      {:ok, %Resource{}}

      iex> update_resource(resource, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_resource(%Resource{} = resource, attrs) do
    resource
    |> Resource.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Resource.

  ## Examples

      iex> delete_resource(resource)
      {:ok, %Resource{}}

      iex> delete_resource(resource)
      {:error, %Ecto.Changeset{}}

  """
  def delete_resource(%Resource{} = resource) do
    Repo.delete(resource)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking resource changes.

  ## Examples

      iex> change_resource(resource)
      %Ecto.Changeset{source: %Resource{}}

  """
  def change_resource(%Resource{} = resource) do
    Resource.changeset(resource, %{})
  end

  @doc """
  Creates or updates a vote for a resource
  """
  def add_vote(attrs) do
    delete_vote(attrs)
    %Votes{}
    |> Votes.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns true if the vote already exists
  """
  def vote_exists?(%{"user_id" => user_id, "resource_id" => resource_id, "up" => up}) do
    not is_nil(Repo.one(from vote in Votes,
              where: vote.user_id == ^user_id and vote.resource_id == ^resource_id and vote.up == ^up))
  end

  @doc """
  Deletes the vote
  """
  def delete_vote(%{"user_id" => user_id, "resource_id" => resource_id}) do
    Repo.delete_all(from vote in Votes,
        where: vote.user_id == ^user_id and vote.resource_id == ^resource_id)
  end

  @doc """
  Adds a comment to a resource
  """
  def add_comment(attrs \\ %{}) do
    %Comments{}
    |> Comments.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets a comment by id
  """
  def get_comment(id) do
    Repo.get(Comments, id)
  end

  @doc """
  Updates a comment
  """
  def update_comment(%Comments{} = comment, attrs) do
    comment
    |> Comments.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment
  """
  def delete_comment(%Comments{} = comment) do
    Repo.delete(comment)
  end
end
