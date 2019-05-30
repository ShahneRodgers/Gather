defmodule Gather.Resources.ResourceLanguages do
  use Ecto.Schema
  import Ecto.Changeset

  alias Gather.Resources.Resource

  schema "resource_languages" do
    field :language, :string
    belongs_to(:resource, Resource)
  end

  @doc false
  def changeset(languages, attrs) do
    languages
    |> cast(attrs, [:language, :resource_id])
    |> validate_required([:language, :resource_id])
    |> foreign_key_constraint(:resource_id)
  end
end
