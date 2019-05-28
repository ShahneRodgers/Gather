defmodule Gather.Repo.Migrations.AddUserEnglishDetails do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :english_level, :integer
      add :english_school, :string
    end
  end
end
