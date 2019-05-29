defmodule Gather.Repo.Migrations.CreateResources do
  use Ecto.Migration

  def change do
    create table(:resources) do
      add :link, :string
      add :summary, :string
      add :language, :string
      add :format, :string
      add :score, :integer
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:resources, [:user_id])
  end
end
