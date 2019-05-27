defmodule Gather.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :task, :string
      add :completed, :boolean, default: false, null: false
      add :user, :integer

      timestamps()
    end

  end
end
