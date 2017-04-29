defmodule Main.OfficeController do
  use Main.Web, :controller

  alias Main.Office

  def index(conn, _params) do
    offices = Repo.all(Office)
    render(conn, "index.html", offices: offices)
  end

  def new(conn, _params) do
    changeset = Office.changeset(%Office{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"office" => office_params}) do
    changeset = Office.changeset(%Office{}, office_params)

    case Repo.insert(changeset) do
      {:ok, _office} ->
        conn
        |> put_flash(:info, "Office created successfully.")
        |> redirect(to: office_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    # office = Repo.get!(Office, id)
    office = Main.Models.OldOffice.find(id)
    render(conn, "show.html", office: office)
  end

  def edit(conn, %{"id" => id}) do
    office = Repo.get!(Office, id)
    changeset = Office.changeset(office)
    render(conn, "edit.html", office: office, changeset: changeset)
  end

  def update(conn, %{"id" => id, "office" => office_params}) do
    office = Repo.get!(Office, id)
    changeset = Office.changeset(office, office_params)

    case Repo.update(changeset) do
      {:ok, office} ->
        conn
        |> put_flash(:info, "Office updated successfully.")
        |> redirect(to: office_path(conn, :show, office))
      {:error, changeset} ->
        render(conn, "edit.html", office: office, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    office = Repo.get!(Office, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(office)

    conn
    |> put_flash(:info, "Office deleted successfully.")
    |> redirect(to: office_path(conn, :index))
  end
end
