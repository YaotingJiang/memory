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
     numOfmatch: 0,
     card1: nil,
     card2: nil,
    timeout: false,
     players: %{},
   }
  end

  def checkTimeout(game) do
    c1 = game.card1
    c2 = game.card2
    if c1 != nil && c2 != nil do
      true
      IO.puts("true, in timeout")
    else
      false
    end
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
     g = matchOrNot(game, user)
     if(g) do
       IO.puts("g timeout")
       IO.inspect(g.timeout)
       g = Map.put(game, :timeout, g.timeout)
       ps = Enum.map g.players, fn {pn, pi} ->
        %{ name: pn, guesses: Enum.into(pi.guesses, []), score: pi.score } end
      %{
         clicks: g.clicks,
         tiles: g.tiles,
         numOfmatch: g.numOfmatch,
         card1: g.card1,
         card2: g.card2,
         players: ps,
         timeout: g.timeout,
         #cooldown: get_cd(g, user),
       }
     else
      ps = Enum.map game.players, fn {pn, pi} ->
        %{ name: pn, guesses: Enum.into(pi.guesses, []), score: pi.score } end
      %{
       clicks: game.clicks,
       tiles: game.tiles,
       numOfmatch: game.numOfmatch,
       card1: game.card1,
       card2: game.card2,
       players: ps,
       timeout: game.timeout,
       #cooldown: get_cd(game, user),
     }
   end
 end

   def matchOrNot(game, user) do
       match = game.numOfmatch + 1
       if(game.card1 != nil && game.card2 != nil) do
         Map.put(game, :timeout, false)
       idx1 = Enum.find_index(game.tiles, fn(x)-> x.index == game.card1.index end)
       idx1 = Enum.find_index(game.tiles, fn(x)-> x.index == game.card2.index end)
     if game.card1.tileStatus == "flipped" && game.card2.tileStatus == "flipped" do
       if game.card1.letter == game.card2.letter do
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
          numOfmatch: match,
          card1: nil,
          card2: nil,
          timeout: true,
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
           numOfmatch: game.numOfmatch,
           card1: nil,
           card2: nil,
           timeout: true,
           }
         end
     else
       game
     end
    end
   end


   def convert_to_atom(params) do
     for {key, val} <- params, into: %{}, do: {String.to_atom(key), val}
   end

   def replaceTiles(game, user, tile) do
    firstTile = convert_to_atom(tile)

    if firstTile.tileStatus != "checked" && !(game.card1 != nil && game.card2 != nil) do
      secondTile = Map.put(firstTile, :tileStatus, "flipped")
      trackclick = game.clicks + 1
      if game.card1 == nil do
        idx1 = Enum.find_index(game.tiles, fn(x)-> x.index == secondTile.index end)
        newtiles = List.replace_at(game.tiles, idx1,
        %{
          letter: Enum.at(game.tiles, idx1).letter,
          index: Enum.at(game.tiles, idx1).index,
          tileStatus: "flipped",
          })
         Map.put(game, :tiles, newtiles)
         |> Map.put(:clicks, trackclick)
         |> Map.put(:card1, secondTile)

      else
         if firstTile.index != game.card1.index do
           idx2 = Enum.find_index(game.tiles, fn(x)-> x.index == secondTile.index end)
           newtiles = List.replace_at(game.tiles, idx2,
           %{
             letter: Enum.at(game.tiles, idx2).letter,
             index: Enum.at(game.tiles, idx2).index,
             tileStatus: "flipped",
           })
            Map.put(game, :tiles, newtiles)
            |> Map.put(:clicks, trackclick)
            |> Map.put(:card2, secondTile)
         else
            game
         end
      end
    else
      game
    end
   end
end
