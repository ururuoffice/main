defmodule Main.OfficeChannel do
  use Main.Web, :channel

  def join("office:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("take_place", %{office_id: office_id, from_id: from_id, to_id: to_id, user: user}, socket) do
    #broadcast! socket, "ping", payload
    office = Main.Models.Office.find office_id

    case Main.Office.take_place(office, to_id, user) do
      {:error, message} -> broadcast! socket, "place_taken", %{error: message}
      {:ok,    place_id} ->
        if from_id do
          Main.Office.leave_place office, from_id, user
        end

        broadcast! socket, "place_taken", %{place_id: place_id}
    end

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end