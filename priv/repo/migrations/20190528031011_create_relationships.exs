defmodule Gather.Repo.Migrations.CreateRelationships do
  use Ecto.Migration

  def change do
    create table(:relationships) do
      add :name, :string
      add :type, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:relationships, [:user_id])
  end
end
