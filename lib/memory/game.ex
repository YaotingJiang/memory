defmodule Memory.Game do

  def new do
    # letters = ["A", "B", "C", "D", "E", "F", "G", "H"]
    # doubleletters = letters ++ letters
    # |> Enum.with_index(1)
    # |> Enum.map(fn {k,v}->{v,k} end)
    # |> Map.new
    # random = Enum.shuffle(doubleletters)
    # update = Enum.map(random, fn {index, x} -> %{letter: x, index: index, flipped: false, checked: false} end)

    update = Enum.shuffle([
      %{letter: "A", index: 0, flipped: false, checked: false},
      %{letter: "A", index: 1, flipped: false, checked: false},
      %{letter: "B", index: 2, flipped: false, checked: false},
      %{letter: "B", index: 3, flipped: false, checked: false},
      %{letter: "C", index: 4, flipped: false, checked: false},
      %{letter: "C", index: 5, flipped: false, checked: false},
      %{letter: "D", index: 6, flipped: false, checked: false},
      %{letter: "D", index: 7, flipped: false, checked: false},
      %{letter: "E", index: 8, flipped: false, checked: false},
      %{letter: "E", index: 9, flipped: false, checked: false},
      %{letter: "F", index: 10, flipped: false, checked: false},
      %{letter: "F", index: 11, flipped: false, checked: false},
      %{letter: "G", index: 12, flipped: false, checked: false},
      %{letter: "G", index: 13, flipped: false, checked: false},
      %{letter: "H", index: 14, flipped: false, checked: false},
      %{letter: "H", index: 15, flipped: false, checked: false},
    ])

    # |> Enum.shuffle(update)

    %{
      # letters: letters,
      updatedTiles: update,
      flippedTiles: [],
      # doubleTiles: doubleletters,
      # randomTiles: Enum.shuffle(letters ++ letters),
      score: 0,
    }
  end



  def client_view(game) do
    %{
      # letters: game.letters,
      updatedTiles: game.updatedTiles,
      flippedTiles: game.flippedTiles,
      # doubleTiles: game.doubleTiles,
      # randomTiles: game.randomTiles,
      score: game.score,
    }
  end

  def checkMatch(game) do
    up = game.updatedTiles
    fl = game.flippedTiles

    index1 = Enum.at(fl, 0).index
    index2 = Enum.at(fl, 1).index

    if Enum.at(fl, 0).element == Enum.at(fl, 1).element &&
       Enum.at(fl, 0).index != Enum.at(fl, 1).element do

       newuplist1 = List.replace_at(up, index1, Map.put(Enum.at(up, index1), :checked, true))
                  |> List.replace_at(index2, Map.put(Enum.at(up, index2), :checked, true))

       Map.put(game, :updatedTiles, newuplist1)
       # IO.puts inspect(game)
    else

      newuplist2 = List.replace_at(up, index1, Map.put(Enum.at(up, index1), :flipped, false))
                 |> List.replace_at(index2, Map.put(Enum.at(up, index2), :flipped, false))

      Map.put(game, :updatedTiles, newuplist2)
            |> Map.put(:flippedTiles, [])
    end

    Map.put(game, :updatedTiles, game.updatedTiles)
          |> Map.put(:flippedTiles, [])
  end


  def checkEquals(game, element, index) do
    IO.inspect(game.flippedTiles);
    if length(game.flippedTiles) == 2 do
      # Process.sleep(1000)
      # :timer.apply_after(1000, checkMatch(game))
      Process.send_before(checkMatch(game), :ping, 1000)
      # game = checkMatch(game)
    else
      game = pushletter(game, element, index);
      if length(game.flippedTiles) == 2 do
        # Process.sleep(1000)
        # :timer.apply_after(1000, checkMatch(game))
        :timer.apply_before(1000, game = checkMatch(game))
        # IO.puts inspect(length(game.flippedTiles))
        # game = checkMatch(game)
      else
        # Process.sleep(1000)
        game
      end
    end
  end


  # def checkNotEquals(game, element, index) do
  #   if length(game.flippedTiles) != 2 do
  #     game = pushletter(game, element, index);
  #     if length(game.flippedTiles) == 2 do
  #       Process.sleep(1000)
  #       game = checkMatch(game)
  #     else
  #         # Process.sleep(1000)
  #       game
  #     end
  #   end
  # end


  def pushletter(game, element, index) do
    up = game.updatedTiles
    newuplist = List.replace_at(up, index, Map.put(Enum.at(up, index), :flipped, true))

    fl = game.flippedTiles

    newfllist = [%{index: index, element: element}]

    game = Map.put(game, :updatedTiles, newuplist)
            |> Map.put(:flippedTiles, newfllist)

    # IO.puts "DEBUG i=#{index}"
    # IO.puts inspect(game)
    # game
  end
end
