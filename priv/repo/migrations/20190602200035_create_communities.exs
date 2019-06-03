defmodule Gather.Repo.Migrations.CreateCommunities do
  use Ecto.Migration

  def change do
    create table(:communities) do
      add :name, :string
      add :region, :string
      add :summary, :string
      add :link, :string
      add :creator, references(:users, on_delete: :nothing)
    end

    create index(:communities, [:creator])
  end
end
