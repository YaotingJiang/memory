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


  def handle_in("replaceTiles", %{"tile" => tile}, socket) do
    view = GameServer.replaceTiles(socket.assigns[:game], socket.assigns[:user], tile)
    # game = Game.replaceTiles(socket.assigns[:game], socket.assigns[:user], tile)
    # if game.card1 != nil && game.card2 != nil do
    #   IO.puts("DEBUG")
    #   IO.puts inspect(game.card1)
    #   IO.puts inspect(game.card2)
    #   {:reply, {:matchOrNot, %{"game" => view}}, socket}
    #   # {:reply, {:matchOrNot, %{"game" => view)}}, socket}
    # else
      {:reply, {:ok, %{"game" => view}}, socket}
    # end
  end

  def handle_in("matchOrNot", %{}, socket) do
    view = GameServer.matchOrNot(socket.assigns[:game], socket.assigns[:user])
    {:reply, {:ok, %{"game" => view}}, socket}
  end



  # def handle_in("matchOrNot", %{}, socket) do
  #   game = Game.checkMatch(socket.assigns[:game])
  #   socket = assign(socket, :game, game)
  #   Memory.BackupAgent.put(socket.assigns[:name], socket.assigns[:game])
  #   {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  # end

    # def handle_in("new", %{}, socket) do
    #   game = Game.new()
    #   Memory.BackupAgent.put(socket.assigns[:game])
    #   socket = assign(socket, :game, game)
    #   {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
    # end

    # def handle_in("replaceTiles", %{"tile" => tile}, socket) do
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
