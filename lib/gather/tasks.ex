defmodule Gather.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias Gather.Repo

  alias Gather.Tasks.{Task, Subtask, Resources, Comments, UserCompletedTask}

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks(region) do
    Repo.all(from task in Task,
            left_join: comment in assoc(task, :comments),
            left_join: subtask in assoc(task, :subtasks),
            left_join: resource in assoc(subtask, :resources),
            left_join: language in assoc(resource, :languages),
            where: is_nil(resource.region) or resource.region == ^region,
            preload: [subtasks: {subtask, resources: {resource, [languages: language]}}, comments: comment]
            )
  end

  @doc """
  Returns the list of subtasks.

  ## Examples

      iex> list_subtasks()
      [%Subtask{}, ...]

  """
  def list_subtasks do
    Repo.all(Subtask)
  end

  def list_user_completed_subtask_ids(user) do
    Repo.all(from ut in UserCompletedTask,
            where: ut.user_id == ^user.id,
            select: ut.subtask_id)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a subtask.
  """
  def create_subtask(attrs \\ %{}) do
    %Subtask{}
    |> Subtask.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates an association between a subtask and a resource.
  """
  def create_subtask_resource(attrs \\ %{}) do
    %Resources{}
    |> Resources.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{source: %Task{}}

  """
  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subtask changes.

  ## Examples

      iex> change_subtask(task)
      %Ecto.Changeset{source: %Subtask{}}

  """
  def change_subtask(%Subtask{} = subtask) do
    Subtask.changeset(subtask, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subtask changes.

  ## Examples

      iex> change_subtask(task)
      %Ecto.Changeset{source: %Subtask{}}

  """
  def change_resource(%Resources{} = resource) do
    Resources.changeset(resource, %{})
  end

  @doc """
  Adds a comment to a task
  """
  def add_comment(attrs \\ %{}) do
    %Comments{}
    |> Comments.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Marks a task as completed
  """
  def add_completed(attrs) do
    delete_completed(attrs)
    %UserCompletedTask{}
    |> UserCompletedTask.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Unmarks a task as completed
  """
  def delete_completed(%{"subtask_id" => subtask, "user_id" => user}) do
    Repo.delete_all(from uct in UserCompletedTask,
                    where: uct.subtask_id == ^subtask and uct.user_id == ^user)
  end

  @doc """
  Returns true if the user has already completed the task
  """
  def user_completed_task?(%{"subtask_id" => subtask, "user_id" => user}) do
    not is_nil(Repo.one(from uct in UserCompletedTask,
                        where: uct.subtask_id == ^subtask and uct.user_id == ^user))
  end
end
