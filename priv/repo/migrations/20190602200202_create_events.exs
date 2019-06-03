defmodule Gather.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :time, :naive_datetime
      add :region, :string
      add :address, :string
      add :link, :string
      add :summary, :string
      add :author, references(:users, on_delete: :nothing)
    end

    create index(:events, [:author])
  end
end
