defmodule Main.UserChannel do
  use Main.Web, :channel

  def join("user:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def join("user:" <> _user_id, payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("message_for_user:" <> user_id, %{"type" => type, "message" => message}, socket) do
    Main.Endpoint.broadcast "user:" <> user_id, type, %{message: message}

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
