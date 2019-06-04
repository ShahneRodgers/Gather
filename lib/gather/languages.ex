defmodule Gather.Languages do
  @languages %{
    "en" => "English",
    "my" => "Burmese",
  }

  def get_languages() do
    @languages
  end

  def set_language(language) do
    Map.get(@languages, language, "en")
  end
end
