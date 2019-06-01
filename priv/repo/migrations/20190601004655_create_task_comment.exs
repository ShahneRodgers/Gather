defmodule Gather.Repo.Migrations.CreateTaskComment do
  use Ecto.Migration

  def change do
    create table(:task_comment) do
      add :comment, :string
      add :task_id, references(:tasks, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:task_comment, [:task_id])
    create index(:task_comment, [:user_id])
  end
end
