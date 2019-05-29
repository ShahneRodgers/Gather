defmodule Gather.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :category, :string
      add :resource_id, references(:resources, on_delete: :delete_all)

      timestamps()
    end

    create index(:categories, [:resource_id])
  end
end
