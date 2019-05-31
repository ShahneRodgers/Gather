defmodule Gather.Repo.Migrations.MakeUniqueFields do
  use Ecto.Migration

  def change do
    create unique_index(:categories, [:category, :resource_id])
    alter table(:categories) do
      remove :id
      modify :category, :text, primary_key: true
      modify :resource_id, :id, primary_key: true
    end

    create unique_index(:resource_languages, [:language, :resource_id])
    alter table(:resource_languages) do
      remove :id
      modify :language, :text, primary_key: true
      modify :resource_id, :id, primary_key: true
    end

    create unique_index(:languages, [:language, :user_id])
    alter table(:languages) do
      remove :id
      modify :language, :text, primary_key: true
      modify :user_id, :id, primary_key: true
    end

    create unique_index(:relationships, [:name, :type, :user_id])
    alter table(:relationships) do
      remove :id
      modify :name, :text, primary_key: true
      modify :type, :text, primary_key: true
      modify :user_id, :id, primary_key: true
    end

    create unique_index(:votes, [:resource_id, :user_id])
    alter table(:votes) do
      remove :id
      modify :resource_id, :id, primary_key: true
      modify :user_id, :id, primary_key: true
    end
  end
end
