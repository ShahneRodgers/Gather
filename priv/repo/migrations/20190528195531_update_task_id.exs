defmodule Gather.Repo.Migrations.UpdateTaskId do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      remove :task
      add :task, :integer
    end
  end
end
