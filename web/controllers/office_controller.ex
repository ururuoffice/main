defmodule Main.OfficeController do
  use Main.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, %{"id" => _id}) do
    office = %{
      id: "1",
      title: "JetrubyOffice",
      rooms: [
        %{
          id: "1",
          title: "",
          dimentions: %{ width: "220px", height: "220px", top: "220px", left: "500px" },
          places: [
            %{
              id: "1",
              title: "",
              coords: %{ top: "10px", left: "10px" },
              user: nil
            },
            %{
              id: "2",
              title: "",
              coords: %{ top: "10px", left: "70px" },
              user: nil
            },
            %{
              id: "3",
              title: "",
              coords: %{ top: "10px", left: "130px" },
              user: nil
            },
          ],
        },
        %{
          title: "",
          dimentions: %{ width: "220px", height: "220px", top: "220px", left: "1000px" },
          places: [
            %{
              id: "1",
              title: "",
              coords: %{ top: "10px", left: "10px" },
              user: nil
            },
            %{
              id: "2",
              title: "",
              coords: %{ top: "10px", left: "70px" },
              user: nil
            },
            %{
              id: "3",
              title: "",
              coords: %{ top: "10px", left: "130px" },
              user: nil
            },
          ],
        }
      ]
    }

    render conn, "show.json", office: office
  end
end
