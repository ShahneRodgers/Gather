defmodule Gather.Repo.Migrations.RedoTask do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :title, :string
      add :order, :integer, unique: true

      remove :task
      remove :completed
      remove :user_id
      remove :inserted_at
      remove :updated_at
    end
  end
end
