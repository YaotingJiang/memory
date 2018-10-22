defmodule Memory.GameServer do
  use GenServer

  alias Memory.Game

  ## Client Interface
  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def view(game, user) do
    GenServer.call(__MODULE__, {:view, game, user})
  end

  def cooled(game, user) do
    GenServer.call(__MODULE__, {:cooled, game, user})
  end

  def replaceTiles(game, user, tile) do
    GenServer.call(__MODULE__, {:replaceTiles, game, user, tile})
  end

  def matchOrNot(game, user) do
    GenServer.call(__MODULE__, {:matchOrNot, game, user})
  end


  def addplayer(game, user) do
    GenServer.call(__MODULE__, {:addplayer, game, user})
  end

  ## Implementations
  def init(state) do
    {:ok, state}
  end

  def handle_call({:join, game, user}, _from, state) do
    gg = Game.addplayer(game, user)
    broadcast(Game.client_view(gg, user), game)
    {:nonreply, Map.put(state, game, gg)}
  end

  def broadcast(state, game) do
    MemoryWeb.Endpoint.broadcast("games: " <> game, "newview", state)
  end

  def handle_call({:view, game, user}, _from, state) do
    gg = Map.get(state, game, Game.new)
    {:reply, Game.client_view(gg, user), Map.put(state, game, gg)}
  end

  def handle_call({:replaceTiles, game, user, tile}, _from, state) do
    gg = Map.get(state, game, Game.new)
    |> Game.replaceTiles(user, tile)
    vv = Game.client_view(gg, user)
    {:reply, vv, Map.put(state, game, gg)}
  end

  def handle_call({:cooled, game, user}, _from, state) do
    gg = Map.get(state, game, Game.new)
    |> Game.cooled(user)
    vv = Game.client_view(gg, user)
    {:reply, vv, Map.put(state, game, gg)}
  end


  def handle_call({:matchOrNot, game, user}, _from, state) do
    gg = Map.get(state, game, Game.new)
    |> Game.matchOrNot(user)
    vv = Game.client_view(gg, user)
    {:reply, vv, Map.put(state, game, gg)}
  end

  def handle_call({:addplayer, game, user}, _from, state) do
    gg = Map.get(state, game, Game.new)
    |> Game.addplayer(user)
    vv = Game.client_view(gg, user)
    {:reply, vv, Map.put(state, game, gg)}
  end

  # def handle_call()
end
