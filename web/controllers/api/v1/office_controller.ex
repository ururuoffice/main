defmodule Main.Api.V1.OfficeController do
  use Main.Web, :controller

  alias Main.Office

  def index(conn, _params) do
    offices = Repo.all(Office)
    render(conn, "index.html", offices: offices)
  end

  def show(conn, %{"id" => id}) do
    office = Repo.get!(Office, id)
    render(conn, "show.html", office: office)
    |> put_flash(:info, "Office deleted successfully.")
  end
end
