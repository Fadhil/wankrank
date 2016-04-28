defmodule Wankrank.RoomChannelTest do
  use Wankrank.ChannelCase

  alias Wankrank.RoomChannel
  alias Wankrank.UserSocket

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(RoomChannel, "rooms:lobby")

    {:ok, socket: socket}
  end

  test "join rooms:lobby" do
    {:ok, socket} = connect(UserSocket, %{"some" => "params"})
    assert {:ok, _, newsocket} = subscribe_and_join(
      socket, "rooms:lobby", %{}
    )
  end

  test "join rooms:someprivateroom" do
    {:ok, socket} = connect(UserSocket, %{})
    assert {:error, _reason} = subscribe_and_join(
      socket, "rooms:a_private_room", %{}
    )
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "shout broadcasts to rooms:lobby", %{socket: socket} do
    push socket, "shout", %{"hello" => "all"}
    assert_broadcast "shout", %{"hello" => "all"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
