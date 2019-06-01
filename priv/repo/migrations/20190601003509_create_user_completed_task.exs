defmodule Gather.Repo.Migrations.CreateUserCompletedTask do
  use Ecto.Migration

  def change do
    create table(:user_completed_task, primary_key: false) do
      add :subtask_id, references(:subtask, on_delete: :delete_all), primary_key: true
      add :user_id, references(:users, on_delete: :delete_all), primary_key: true
    end

    create index(:user_completed_task, [:subtask_id])
    create index(:user_completed_task, [:user_id])
  end
end
