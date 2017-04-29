defmodule Main.Office do
  use GenServer

  def new(office) do
    pid = whereis(office)

    case pid do
      nil -> start_link(office)
      _ -> pid
    end
  end

  defp start_link(office) do
    {:ok, pid} = GenServer.start_link(
        __MODULE__,
        office,
        name: process_name(office)
      )

    pid
  end

  defp process_name(office) do
    String.to_atom("office_state:" <> office.id)
  end

  def whereis(office) do
    process_name(office) |> Process.whereis
  end

  def get_state(office) do
    whereis(office) |> GenServer.call(:get_state)
  end

  def leave_place(office, room_id, place_id) do
    new_state = put_in get_state(office), [:rooms, room_id, :places, place_id, :user], nil
    update(new_state, office)

    {:ok}
  end

  def take_place(office, room_id, user_id) do
    state = get_state(office)

    case find_free_place(state, room_id) do
      nil ->
        {:error, "No free places"}
      place_id ->
        new_state = put_in state, [:rooms, room_id, :places, place_id, :user], user_id
        update(new_state, office)

        {:ok, place_id}
    end
  end

  defp find_free_place(state, room_id) do
    free_places = Map.to_list(state.rooms[room_id].places)
                  |> Enum.filter(fn({_id, place}) -> place[:user] == nil end)

    case free_places do
      [] -> nil
      [{id, _} | _] -> id
    end
  end

  def update(new_state, office) do
    whereis(office) |> GenServer.call({:update, new_state})
  end

  def handle_call(:get_state, _from, office) do
    {:reply, office, office}
  end

  def handle_call({:update, new_state}, _from, _office) do
    {:reply, :ok, new_state}
  end
end
