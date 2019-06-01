defmodule Gather.Repo.Migrations.AddRegionToResource do
  use Ecto.Migration

  def change do
    alter table(:resources) do
      add :region, :string
    end
  end
end
