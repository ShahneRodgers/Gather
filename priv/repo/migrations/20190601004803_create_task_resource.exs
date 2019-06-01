defmodule Gather.Repo.Migrations.CreateTaskResource do
  use Ecto.Migration

  def change do
    create table(:task_resource, primary_key: false) do
      add :subtask_id, references(:subtask, on_delete: :delete_all), primary_key: true
      add :resource_id, references(:resources, on_delete: :delete_all), primary_key: true
    end

    create index(:task_resource, [:subtask_id])
    create index(:task_resource, [:resource_id])
  end
end
