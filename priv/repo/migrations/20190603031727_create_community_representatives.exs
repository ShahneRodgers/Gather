defmodule Gather.Repo.Migrations.CreateCommunityRepresentatives do
  use Ecto.Migration

  def change do
    create table(:community_representatives, primary_key: false) do
      add :email, :string
      add :phone, :string
      add :about, :string
      add :user_id, references(:users, on_delete: :delete_all), primary_key: true
    end
  end
end
