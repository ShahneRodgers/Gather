defmodule Gather.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :password_hash, :string
      add :arrival, :date
      add :region, :string
      add :nickname, :string
      add :is_leader, :boolean

      timestamps()
    end

  end
end
