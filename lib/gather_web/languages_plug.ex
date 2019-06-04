defmodule GatherWeb.Languages.LanguagesPlug do
  import Plug.Conn
  import GatherWeb.Gettext

  @locales Gettext.known_locales(GatherWeb.Gettext)

  def init(_) do
  end

  def call(%Plug.Conn{params: %{"locale" => locale}} = conn, _opts) when locale in @locales do
    conn
    |> put_locale_and_cookie(locale)
    |> assign_languages()
  end

  def call(conn, _) do
    locale = conn.cookies["locale"]
    if validate_locale(locale) do
      Gettext.put_locale(GatherWeb.Gettext, locale)
      conn
    else
      locale = locale_from_header(conn)
      if not is_nil(locale) do
        put_locale_and_cookie(conn, locale)
      else
        conn
      end
    end
    |> assign_languages()
  end

  defp put_locale_and_cookie(conn, locale) do
    Gettext.put_locale(GatherWeb.Gettext, locale)
    put_resp_cookie(conn, "locale", locale, max_age: 365*24*60*60) # Persist for a year
  end

  defp assign_languages(conn) do
    assign(conn, :available_languages, Gather.Languages.get_languages())
  end

  defp validate_locale(locale) do
    Enum.member?(@locales, locale)
  end

  defp locale_from_header(conn) do
    # Copied from: https://phraseapp.com/blog/posts/set-and-manage-locale-data-in-your-phoenix-l10n-project/
    conn
    |> extract_accept_language
    |> Enum.find(nil, fn accepted_locale -> Enum.member?(@locales, accepted_locale) end)
  end

  def extract_accept_language(conn) do
    case Plug.Conn.get_req_header(conn, "accept-language") do
      [value | _] ->
        value
        |> String.split(",")
        |> Enum.map(&parse_language_option/1)
        |> Enum.sort(&(&1.quality > &2.quality))
        |> Enum.map(&(&1.tag))
        |> Enum.reject(&is_nil/1)
        |> ensure_language_fallbacks()

        _ ->
        []
      end
    end

    defp parse_language_option(string) do
      captures = Regex.named_captures(~r/^\s?(?<tag>[\w\-]+)(?:;q=(?<quality>[\d\.]+))?$/i, string)

      quality = case Float.parse(captures["quality"] || "1.0") do
        {val, _} -> val
        _ -> 1.0
      end

      %{tag: captures["tag"], quality: quality}
    end

    defp ensure_language_fallbacks(tags) do
      Enum.flat_map tags, fn tag ->
        [language | _] = String.split(tag, "-")
        if Enum.member?(tags, language), do: [tag], else: [tag, language]
      end
    end
end
