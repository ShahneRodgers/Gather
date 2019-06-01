defmodule Gather.Repo.Migrations.CreateSubtask do
  use Ecto.Migration

  def change do
    create table(:subtask) do
      add :title, :string, unique: true
      add :task_id, references(:tasks, on_delete: :delete_all)
    end

    create index(:subtask, [:task_id])
  end
end
