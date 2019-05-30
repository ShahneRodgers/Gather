defmodule Gather.Repo.Migrations.AddResourceTitle do
  use Ecto.Migration

  def change do
    alter table(:resources) do
      add :title, :string
    end
  end
end
