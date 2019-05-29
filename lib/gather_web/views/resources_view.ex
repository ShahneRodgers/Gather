defmodule GatherWeb.ResourcesView do
  use GatherWeb, :view

  defp get_category_name(category) do
    case category do
      :housing -> gettext("Housing")
      :work -> gettext("Work")
      :education -> gettext("Education")
      :transport -> gettext("Transport")
      :health -> gettext("Health")
      :law -> gettext("Government & Law")
      :service_providers -> gettext("Service providers")
      :communities -> gettext("Communities")
      _ -> gettext("Other")
    end
  end
end
