defmodule Gather.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :comment, :text
      add :resource_id, references(:resources, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:comments, [:resource_id])
    create index(:comments, [:user_id])
  end
end
