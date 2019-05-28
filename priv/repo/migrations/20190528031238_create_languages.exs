defmodule Gather.Repo.Migrations.CreateLanguages do
  use Ecto.Migration

  def change do
    create table(:languages) do
      add :language, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:languages, [:user_id])
  end
end
