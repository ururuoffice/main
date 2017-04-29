defmodule Main.OfficeChannel do
  use Main.Web, :channel

  def join("office:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("join_office:" <> office_id, _payload, socket) do
    office = Main.Models.OldOffice.find office_id
    Main.OfficeServer.new office

    broadcast! socket, "office_updated", Main.OfficeServer.get_state(office)
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("take_place", %{"office_id" => office_id, "from_id" => from_id, "to_id" => to_id, "user" => user}, socket) do
    #broadcast! socket, "ping", payload
    office = Main.Models.OldOffice.find office_id

    case Main.OfficeServer.take_place(office, to_id, user) do
      {:error, message} -> broadcast! socket, "place_taken", %{error: message}
      {:ok,    place_id} ->
        if from_id do
          Main.OfficeServer.leave_place office, from_id, user
        end

        broadcast! socket, "office_updated", Main.OfficeServer.get_state(office)
    end

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
