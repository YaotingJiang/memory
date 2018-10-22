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
   #TODO add curPlayer
   %{
     tiles: initializeTiles,
     clicks: 0,
     numOfmatch: 0,
     card1: nil,
     card2: nil,
     timeout: false,
     players: %{},
     observers: %{},
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
        curPlayer: false,
        score: 0,
      }
  end

  def addplayer(game, user) do
    newg = game
    newg = case Enum.count(game.players) do
      0 ->
        player = default_player()
        |> Map.put(:curPlayer, true)
        newplayers = Map.put(game.players, user, player)
        # IO.inspect(newplayers)
        newg = game
        |> Map.put(:players, newplayers)

     1 ->
        player = default_player()
        newg = game
        |> Map.put(:players, Map.put(game.players, user, player))
     _ ->
        observer = default_player()
        newg = game
        |> Map.put(:observers, Map.put(game.observers, user, observer))
    end

    # IO.inspect(newg)
    # IO.inspect(newg.players[user])
    # newg.players[user]
    # newg
  end

  #after player cooldown is up, determine state of touched cards, change turn
  def cooled(game, user) do
    #TODO change curPlayer, change card appearance if matched, otherwise flip
    idx1 = Enum.find_index(game.tiles, fn(x)-> x.index == game.card1.index end)
    idx2 = Enum.find_index(game.tiles, fn(x)-> x.index == game.card2.index end)


    newtiles = game.tiles
    if game.card1.letter == game.card2.letter do
      IO.puts("COOLED: match found")
      # newScore = game.players[user].score + 1


      newtiles = List.replace_at(game.tiles, idx1,
      %{
        letter: Enum.at(game.tiles, idx1).letter,
        index: Enum.at(game.tiles, idx1).index,
        tileStatus: "checked",
      }
      )
      |>List.replace_at(idx2,
      %{
        letter: Enum.at(game.tiles, idx2).letter,
        index: Enum.at(game.tiles, idx2).index,
        tileStatus: "checked",
      })

        newplayers = Enum.map(game.players, fn {p, x} ->
        {p, %{
          curPlayer: !x.curPlayer,
          score: if x.curPlayer do x.score + 1 else x.score end,
          }} end)
      newplayers2 = Enum.into(newplayers, %{})

      %{
      clicks: game.clicks,
      tiles: newtiles,
      numOfmatch: game.numOfmatch,
      card1: nil,
      card2: nil,
      timeout: false,
      players: newplayers2,
      observers: game.observers,
      }

      #call change turn here set the game state to be change turn
      # changeTurn(game, 1)
    else
      IO.puts("COOLED: no match")
      newtiles = List.replace_at(game.tiles, idx1,
      %{
        letter: Enum.at(game.tiles, idx1).letter,
        index: Enum.at(game.tiles, idx1).index,
        tileStatus: "notFlipped",
      }
      )
      |>List.replace_at(idx2,
      %{
        letter: Enum.at(game.tiles, idx2).letter,
        index: Enum.at(game.tiles, idx2).index,
        tileStatus: "notFlipped",
      })

      newplayers = Enum.map(game.players, fn {p, x} ->
        {p, %{
          curPlayer: !x.curPlayer,
          score: if x.curPlayer do x.score + 0 else x.score end,
          }} end)
      newplayers2 = Enum.into(newplayers, %{})
      %{
        clicks: game.clicks,
        tiles: newtiles,
        numOfmatch: game.numOfmatch,
        card1: nil,
        card2: nil,
        timeout: false,
        players: newplayers2,
        observers: game.observers,
      }

      # changeTurn(game, 0)
    end
  end

    def checkTimeOut(game) do
      if game.card1 != nil && game.card2 != nil do
        true
      else
        false
      end
    end

    def client_view(game, user) do
      ps = Enum.map game.players, fn {pn, pi} ->
         %{ name: pn, score: pi.score } end
      %{
        clicks: game.clicks,
        tiles: game.tiles,
        numOfmatch: game.numOfmatch,
        card1: game.card1,
        card2: game.card2,
        timeout: checkTimeOut(game),
        players: ps,
        observers: game.observers,
      }
    end


  #TODO change player score if match
  def matchOrNot(game, user) do
    match = game.numOfmatch + 1
    pinfo = game.players[user]

    # if pinfo.curPlayer do

    if(game.card1 != nil && game.card2 != nil) do

      idx1 = Enum.find_index(game.tiles, fn(x)-> x.index == game.card1.index end)
      idx2 = Enum.find_index(game.tiles, fn(x)-> x.index == game.card2.index end)
      if game.card1.tileStatus == "flipped" && game.card2.tileStatus == "flipped" do
        # IO.puts("comparing cur card")
        if game.card1.letter == game.card2.letter do
          # pinfo
          #   |> Map.put(:score, game.score + 1, :curPlayer, false)
          # newplayers = Map.put(game.players, user, pinfo)


          newtiles = List.replace_at(game.tiles, idx1,
            %{
            letter: Enum.at(game.tiles, idx1).letter,
            index: Enum.at(game.tiles, idx1).index,
            tileStatus: "flipped",#"checked",
            }
          )
          |>List.replace_at(idx2,
          %{
            letter: Enum.at(game.tiles, idx2).letter,
            index: Enum.at(game.tiles, idx2).index,
            tileStatus: "flipped",#"checked",
          })

          %{
            tiles: newtiles,
            clicks: game.clicks,
            numOfmatch: match,
            card1: nil,
            card2: nil,
            timeout: true,
            players: game.players, #game.players
          }
        else

          %{
            tiles: game.tiles, #newtiles,
            clicks: game.clicks,
            numOfmatch: game.numOfmatch,
            card1: nil,
            card2: nil,
            timeout: true,
            players: game.players
          }
        end
      else
        game
      end
    end
  # else
  #   game
  # end
end


  def convert_to_atom(params) do
    for {key, val} <- params, into: %{}, do: {String.to_atom(key), val}
  end

   def replaceTiles(game, user, tile) do
    firstTile = convert_to_atom(tile)

    pinfo = Map.get(game.players, user, default_player())

    IO.puts("Debug curplayer")
    IO.puts inspect(game.players)
    IO.puts inspect(pinfo)

    if pinfo.curPlayer do
      if firstTile.tileStatus != "checked" && !(game.card1 != nil && game.card2 != nil) do
        secondTile = Map.put(firstTile, :tileStatus, "flipped")
        trackclick = game.clicks + 1
        if game.card1 == nil do
          IO.puts("Debug here")
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
  else
    game
  end
end

end
