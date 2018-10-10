defmodule MemoryWeb.GamesChannel do
  use MemoryWeb, :channel

  # alias Memory.Game
  alias Memory.GameServer

  # def join("games:" <> name, payload, socket) do
  #     if authorized?(payload) do
  #       game = Memory.BackupAgent.get(name) || Game.new()
  #       socket = socket
  #       |> assign(:game, game)
  #       |> assign(:name, game)
  #       Memory.BackupAgent.put(name, game)
  #       {:ok, %{"join" => name, "game" => Game.client_view(game)}, socket}
  #     else
  #       {:error, %{reason: "unauthorized"}}
  #     end
  #   end

  def join("games:" <> game, payload, socket) do
    if authorized?(payload) do
      socket = assign(socket, :game, game)
      view = GameServer.view(game, socket.assigns[:user])
      {:ok, %{"join" => game, "game" => view}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

    # def handle_in("new", %{}, socket) do
    #   game = Game.new()
    #   Memory.BackupAgent.put(socket.assigns[:game])
    #   socket = assign(socket, :game, game)
    #   {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
    # end

    # def handle_in("checkEquals", %{"tile" => tile}, socket) do
    #   game = Game.checkEquals(socket.assigns[:game], tile)
    #   socket = assign(socket, :game, game)
    #   Memory.BackupAgent.put(socket.assigns[:name], socket.assigns[:game])
    #
    #   # if game.selectedTile1 != nil && game.selectedTile2 != nil do
    #   #   {:reply, {:checkMatch, %{"game" => Game.client_view(game)}}, socket}
    #   # else
    #   if game.selectedTile1 != nil && game.selectedTile2 != nil do
    #     {:reply, {:matchOrNot, %{"game" => Game.client_view(game)}}, socket}
    #   else
    #     {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
    #   end
    # end
    #
    #
    # def handle_in("matchOrNot", %{}, socket) do
    #   game = Game.checkMatch(socket.assigns[:game])
    #   socket = assign(socket, :game, game)
    #   Memory.BackupAgent.put(socket.assigns[:name], socket.assigns[:game])
    #   {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
    # end

    # def handle_in("ping", payload, socket) do
    #   {:reply, {:ok, payload},socket}
    # end
    #
    # def handle_in("shout", payload, socket) do
    #   broadcast socket, "shout", payload
    #   {:nonreply, socket}
    # end

    defp authorized?(_payload) do
      true
    end


end
