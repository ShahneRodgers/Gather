defmodule Gather.Repo.Migrations.CreateCommunityRepresentatives do
  use Ecto.Migration

  def change do
    create table(:community_representatives) do
      add :email, :string
      add :phone, :string
      add :about, :string
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create index(:community_representatives, [:user_id])
  end
end
