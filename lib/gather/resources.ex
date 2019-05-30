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

  def get_by_category(category) do
    Repo.all(from cat in Categories,
             where: cat.category == ^category,
             join: r in Resource, on: cat.resource_id == r.id,
             select: r
             #preload: [categories: r, comments: r, votes: r]
             #order_by: r.score)
    )
    |> Repo.preload([:categories, :comments, :votes, :languages])
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
end
