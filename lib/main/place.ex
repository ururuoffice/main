defmodule Main.Place do
  use GenServer

  @doc"""
    Hardcoded rooms with places
  """
  defp rooms do
    [
      {:meeting_room, places: [%{id: 1, taken: false}, %{id: 2, taken: false}]},
      {:toilet, places: [%{id: 1, taken: true}]}
    ]
  end

  @doc"""
    Hardcoded putting rooms and places to GenServer instance
  """
  def put_rooms(pid) do
    GenServer.cast(pid, {:put_rooms, rooms})
  end

  def rooms_list(pid) do
    GenServer.call(pid, {:rooms})
  end

  def start_link do
    {:ok, pid} = GenServer.start_link(__MODULE__, [])
  end

  def list(pid), do: rooms;
  def list(pid, room_name) do
    [rooms | tail] = rooms_list(pid)
    rooms[room_name]
  end

  def available_list(), do: [];
  def available_list(pid, room_name) do
    list(pid, room_name)[:places]
    |> Enum.filter(fn(place) -> place[:taken] == false end)
  end

  def take(pid, room_name, place_id) do
    GenServer.call(pid, {:take_place, rooms}, room_name, place_id)
  end

  def handle_cast({:put_rooms, item}, rooms) do
    {:noreply, rooms ++ [item]}
  end

  def handle_call(:rooms, _from, rooms) do
    {:reply, rooms, rooms}
  end

  def handle_call(:take_place, _from, rooms) do
    {:reply, rooms, rooms}
  end
end
