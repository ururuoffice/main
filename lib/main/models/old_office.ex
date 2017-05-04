defmodule Main.Models.OldOffice do
  def find(_id) do
    %{
      id: "1",
      width: 1000,
      height: 800,
      title: "JetrubyOffice",
      rooms: %{
        "1" => %{
            title: "Room 1",
            bg_url: "images/conference_table.png",
            dimensions: %{
              width: 280,
              height: 480,
              top: 0,
              right: 0
            },
            places: %{
              "1" => %{
                title: "",
                coords: %{
                  top: 45,
                  left: 119
                },
                user: nil
              },
              "2" => %{
                title: "",
                coords: %{
                  top: 130,
                  left: 38
                },
                user: nil
              },
              "3" => %{
                title: "",
                coords: %{
                  top: 130,
                  right: 38
                },
                user: nil
              },
              "4" => %{
                title: "",
                coords: %{
                  top: 217,
                  left: 38
                },
                user: nil
              },
              "5" => %{
                title: "",
                coords: %{
                  top: 217,
                  right: 38
                },
                user: nil
              },
              "6" => %{
                title: "",
                coords: %{
                  top: 304,
                  left: 38
                },
                user: nil
              },
              "7" => %{
                title: "",
                coords: %{
                  top: 304,
                  right: 38
                },
                user: nil
              },
              "8" => %{
               title: "",
               coords: %{
                 bottom: 43,
                 left: 119
               },
               user: nil
             }
            }
          },
        "2" => %{
          title: "Room 2",
          type: "pull_with_pootanas",
          bg_url: "images/pool_with_sofa.png",
          dimensions: %{
            width: 420,
            height: 260,
            bottom: 0,
            right: 0
          },
          places: %{
            "1" => %{
              title: "",
              coords: %{
                top: 50,
                right: 80
              },
              user: nil
            },
            "2" => %{
              title: "",
              coords: %{
                top: 107,
                right: 80
              },
              user: nil
            },
            "3" => %{
              title: "",
              coords: %{
                top: 167,
                right: 80
              },
              user: nil
            }
          }
        },
          "3" => %{
            title: "Room 3",
            type: "open_space",
            bg_url: "images/open-space.png",
            dimensions: %{
              width: 420,
              height: 786,
              top: 0,
              left: 0
            },
            places: %{
              "1" => %{
                title: "",
                coords: %{
                  top: 70,
                  right: 107
                },
                user: nil
              },
              "2" => %{
                title: "",
                coords: %{
                  top: 70,
                  left: 107
                },
                user: nil
              },
              "3" => %{
                title: "",
                coords: %{
                  bottom: 70,
                  right: 107
                },
                user: nil
              },
              "4" => %{
                title: "",
                coords: %{
                  bottom: 70,
                  left: 107
                },
                user: nil
              },
              "5" => %{
                title: "",
                coords: %{
                  bottom: 284,
                  right: 107
                },
                user: nil
              },
              "6" => %{
                title: "",
                coords: %{
                  bottom: 284,
                  left: 107
                },
                user: nil
              }
          }
        }
      }
    }
  end
end
