defmodule Main.OfficeView do
  use Main.Web, :view

  def render("show.json",  %{office: office}) do
    office
  end
end
