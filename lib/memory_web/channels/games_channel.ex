defmodule MemoryWeb.GamesChannel do
  use MemoryWeb, :channel

  alias Memory.Game
  alias Memory.BackupAgent

  # def join("games:lobby", payload, socket) do
  #   if authorized?(payload) do
  #     {:ok, socket}
  #   else
  #     {:error, %{reason: "unauthorized"}}
  #   end
  # end
  #
  # # Channels can be used in a request/response fashion
  # # by sending replies to requests from the client
  # def handle_in("ping", payload, socket) do
  #   {:reply, {:ok, payload}, socket}
  # end
  #
  # # It is also common to receive messages from the client and
  # # broadcast to everyone in the current topic (games:lobby).
  # def handle_in("shout", payload, socket) do
  #   broadcast socket, "shout", payload
  #   {:noreply, socket}
  # end

  def join("games:" <> name, payload, socket) do
      if authorized?(payload) do
        game = Memory.BackupAgent.get(name) || Game.new()
        socket = socket
        |> assign(:game, game)
        |> assign(:name, game)
        Memory.BackupAgent.put(name, game)
        {:ok, %{"join" => name, "game" => Game.client_view(game)}, socket}
      else
        {:error, %{reason: "unauthorized"}}
      end
    end

    def handle_in("checkEquals", %{"element" => element, "index" => index}, socket) do
      game = Game.checkEquals(socket.assigns[:game], element, index)
      socket = assign(socket, :game, game)
      Memory.BackupAgent.put(socket.assigns[:name], socket.assigns[:game])
      {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
    end

    def handle_in("new", %{}, socket) do
      game = Game.new()
      Memory.BackupAgent.put(socket.assigns[:game])
      socket = assign(socket, :game, game)
      {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
    end

    def handle_in("checkMatch", %{}, socket) do
      game = Game.checkMatch(socket.assigns[:game])
      socket = assign(socket, :game, game)
      Memory.BackupAgent.put(socket.assigns[:name], socket.assigns[:game])
      {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
    end

    # def handle_in("pushletter", %{"element" => element, "index" => index}, socket) do
    #   # game = Game.new()
    #   game = Game.pushletter(socket.assigns[:game])
    #   socekt = assign(socket, :game, game)
    #   Memory.BackupAgent.put(socket.assigns[:name], socket.assigns[:game])
    #   {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
    # end
  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
