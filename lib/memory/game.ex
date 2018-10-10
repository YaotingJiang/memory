defmodule Memory.Game do

  def new do
    initializeTiles = Enum.shuffle([
        %{letter: "A", index: 0, tileStatus: "notFlipped"},
        %{letter: "A", index: 1, tileStatus: "notFlipped"},
        %{letter: "B", index: 2, tileStatus: "notFlipped"},
        %{letter: "B", index: 3, tileStatus: "notFlipped"},
        %{letter: "C", index: 4, tileStatus: "notFlipped"},
        %{letter: "C", index: 5, tileStatus: "notFlipped"},
        %{letter: "D", index: 6, tileStatus: "notFlipped"},
        %{letter: "D", index: 7, tileStatus: "notFlipped"},
        %{letter: "E", index: 8, tileStatus: "notFlipped"},
        %{letter: "E", index: 9, tileStatus: "notFlipped"},
        %{letter: "F", index: 10, tileStatus: "notFlipped"},
        %{letter: "F", index: 11, tileStatus: "notFlipped"},
        %{letter: "G", index: 12, tileStatus: "notFlipped"},
        %{letter: "G", index: 13, tileStatus: "notFlipped"},
        %{letter: "H", index: 14, tileStatus: "notFlipped"},
        %{letter: "H", index: 15, tileStatus: "notFlipped"},
     ])
   %{
     tiles: initializeTiles,
     clicks: 0,
     matchedTiles: 0,
     selectedTile1: nil,
     selectedTile2: nil,
     players: %{}
   }
  end

  def new(players) do
    players = Enum.map players, fn {name, info} ->
      {name, %{ default_player() | score: info.score || 0 }}
    end
    Map.put(new(), :players, Enum.into(players, %{}))
end

def default_player() do
    %{
      score: 0,
      guesses: MapSet.new(),
      cooldown: nil,
    }
end

def get_cd(game, user) do
    done = (get_in(game.players, [user, :cooldown]) || 0)
    left = done - :os.system_time(:milli_seconds)
    max(left, 0)
end

   def client_view(game, user) do
     ps = Enum.map game.players, fn {pn, pi} ->
      %{ name: pn, guesses: Enum.into(pi.guesses, []), score: pi.score } end
      %{
       clicks: game.clicks,
       tiles: game.tiles,
       matchedTiles: game.matchedTiles,
       selectedTile1: game.selectedTile1,
       selectedTile2: game.selectedTile2,
       players: ps,
       cooldown: get_cd(game, user),
     }
   end

   def matchOrNot(game) do
       match = game.matchedTiles + 1
       idx1 = Enum.find_index(game.tiles, fn(x)-> x.index == game.selectedTile1.index end)
       idx1 = Enum.find_index(game.tiles, fn(x)-> x.index == game.selectedTile2.index end)
     if game.selectedTile1.tileStatus == "flipped" && game.selectedTile2.tileStatus == "flipped" do
       if game.selectedTile1.letter == game.selectedTile2.letter do
         newtiles = List.replace_at(game.tiles, idx1,
       %{
         letter: Enum.at(game.tiles, idx1).letter,
         index: Enum.at(game.tiles, idx1).index,
         tileStatus: "checked",
        })
        |>List.replace_at(idx1,
        %{
          letter: Enum.at(game.tiles, idx1).letter,
          index: Enum.at(game.tiles, idx1).index,
          tileStatus: "checked",
        })
        %{
          tiles: newtiles,
          clicks: game.clicks,
          matchedTiles: match,
          selectedTile1: nil,
          selectedTile2: nil,
         }
       else
         newtiles = List.replace_at(game.tiles, idx1,
        %{
          letter: Enum.at(game.tiles, idx1).letter,
          index: Enum.at(game.tiles, idx1).index,
          tileStatus: "notFlipped",
         })
         |>List.replace_at(idx1,
         %{
           letter: Enum.at(game.tiles, idx1).letter,
           index: Enum.at(game.tiles, idx1).index,
           tileStatus: "notFlipped",
         })

         %{
           tiles: newtiles,
           clicks: game.clicks,
           matchedTiles: game.matchedTiles,
           selectedTile1: nil,
           selectedTile2: nil,
           }
         end
     else
       game
     end
   end


   def convert_to_atom(params) do
     for {key, val} <- params, into: %{}, do: {String.to_atom(key), val}
   end

   def checkEquals(game, tile) do
    firstTile = convert_to_atom(tile)

    if firstTile.tileStatus != "checked" && !(game.selectedTile1 != nil && game.selectedTile2 != nil) do
      secondTile = Map.put(firstTile, :tileStatus, "flipped")
      trackclick = game.clicks + 1
      if game.selectedTile1 == nil do
        idx1 = Enum.find_index(game.tiles, fn(x)-> x.index == secondTile.index end)
        newtiles = List.replace_at(game.tiles, idx1,
        %{
          letter: Enum.at(game.tiles, idx1).letter,
          index: Enum.at(game.tiles, idx1).index,
          tileStatus: "flipped",
          })
         Map.put(game, :tiles, newtiles)
         |> Map.put(:clicks, trackclick)
         |> Map.put(:selectedTile1, secondTile)

      else
         if firstTile.index != game.selectedTile1.index do
           idx2 = Enum.find_index(game.tiles, fn(x)-> x.index == secondTile.index end)
           newtiles = List.replace_at(game.tiles, idx2,
           %{
             letter: Enum.at(game.tiles, idx2).letter,
             index: Enum.at(game.tiles, idx2).index,
             tileStatus: "flipped",
           })
            Map.put(game, :tiles, newtiles)
            |> Map.put(:clicks, trackclick)
            |> Map.put(:selectedTile2, secondTile)
         else
            game
         end
      end
    else
      game
    end
   end
end
