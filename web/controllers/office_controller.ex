defmodule Main.OfficeController do
  use Main.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, %{"id" => _id}) do
    office = %{
      id: "1",
      title: "JetrubyOffice",
      rooms: %{
        "1" =>   %{
            title: "Room 1",
            dimentions: %{ width: "220px", height: "220px", top: "220px", left: "500px" },
            places: %{
              "1" => %{
                title: "",
                coords: %{ top: "10px", left: "10px" },
                user: nil
              },
              "2" => %{
                title: "",
                coords: %{ top: "10px", left: "70px" },
                user: nil
              },
              "3" => %{
                title: "",
                coords: %{ top: "10px", left: "130px" },
                user: nil
              }
            }
          },
        "2" => %{
          title: "Room 2",
          dimentions: %{ width: "220px", height: "220px", top: "220px", left: "1000px" },
          places: %{
            "1" => %{
              title: "",
              coords: %{ top: "10px", left: "10px" },
              user: nil
            },
            "2" => %{
              title: "",
              coords: %{ top: "10px", left: "70px" },
              user: nil
            },
            "3" => %{
              title: "",
              coords: %{ top: "10px", left: "130px" },
              user: nil
            }
          }
        }
      }
    }

    render conn, "show.json", office: office
  end
end
