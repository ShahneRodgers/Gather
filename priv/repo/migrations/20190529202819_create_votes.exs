defmodule Gather.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :resource_id, references(:resources, on_delete: :delete_all)
      add :up, :boolean
    end

    alter table(:resources) do
      remove :score
      remove :language
    end

    create table(:resource_languages) do
      add :resource_id, references(:resources, on_delete: :delete_all)
      add :language, :string
    end

    create index(:votes, [:user_id])
    create index(:votes, [:resource_id])
  end
end
