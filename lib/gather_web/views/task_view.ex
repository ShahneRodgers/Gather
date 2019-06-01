defmodule GatherWeb.TaskView do
  use GatherWeb, :view

  def render_shared(template, assigns \\ []) do
    render(GatherWeb.LayoutView, template, assigns)
  end
end
