defmodule Gather.Resources.ResourceLanguages do
  use Ecto.Schema
  import Ecto.Changeset

  alias Gather.Resources.Resource

  @primary_key false
  schema "resource_languages" do
    field :language, :string, primary_key: true
    belongs_to :resource, Resource, primary_key: true
  end

  @doc false
  def changeset(languages, attrs) do
    languages
    |> cast(attrs, [:language, :resource_id])
    |> validate_required([:language, :resource_id])
    |> foreign_key_constraint(:resource_id)
  end
end
