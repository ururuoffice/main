defmodule Main.OfficeController do
  use Main.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, %{"id" => _id}) do
    office = Main.Models.Office.find _id

    render conn, "show.json", office: office
  end
end
