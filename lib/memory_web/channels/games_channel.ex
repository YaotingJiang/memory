defmodule MemoryWeb.GamesChannel do
  use MemoryWeb, :channel

  alias Memory.Game
  alias Memory.GameServer

  def join("games:" <> game, payload, socket) do
    if authorized?(payload) do
      socket = assign(socket, :game, game)
      view = GameServer.view(game, socket.assigns[:user])
      {:ok, %{"join" => game, "game" => view}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end


  def handle_in("replaceTiles", %{"tile" => tile}, socket) do
    view = GameServer.replaceTiles(socket.assigns[:game], socket.assigns[:user], tile)
      {:reply, {:ok, %{"game" => view}}, socket}
  end

  def handle_in("cooled", %{}, socket) do
    view = GameServer.cooled(socket.assigns[:game], socket.assigns[:user])
    {:reply, {:ok, %{"game" => view}}, socket}
  end

  def handle_in("matchOrNot", %{}, socket) do
    view = GameServer.cooled(socket.assigns[:game], socket.assigns[:user])
    {:reply, {:ok, %{"game" => view}}, socket}
  end

  def handle_in("addplayer", %{}, socket) do
    view = GameServer.addplayer(socket.assigns[:game], socket.assigns[:user])
    {:reply, {:ok, %{"game" => view}}, socket}
  end


  def handle_in("newview", payload, socket) do
    broadcast socket, "newview", payload
    {:nonreply, socket}
  end

  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  defp authorized?(_payload) do
      true
  end


end
