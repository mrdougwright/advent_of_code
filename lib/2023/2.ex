import AOC

aoc 2023, 2 do
  @moduledoc """
  https://adventofcode.com/2023/day/2
  """
  @bag %{"red" => 12, "green" => 13, "blue" => 14}

  # input should be txt file as giant string
  def p1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(0, fn game, acc ->
      case game_valid(game) do
        {:ok, id} -> acc + id
        :error -> acc
      end
    end)
  end

  def p2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&game_power/1)
    |> Enum.sum()
  end

  def game_power(game) do
    [_game_id, set_str] = String.split(game, ": ")
    sets = String.replace(set_str, "; ", ", ") |> String.split(", ")
    min_set = min_set_req(sets)

    Enum.reduce(min_set, 1, fn {_cube, val}, acc -> val * acc end)
  end

  def min_set_req(sets) do
    # sets = ["2 red", "3 green", "4 blue"]
    def_bag = %{"red" => 0, "green" => 0, "blue" => 0}

    Enum.reduce(sets, def_bag, fn set, acc ->
      [count, color] = String.split(set, " ")
      int = String.to_integer(count)

      if int > acc[color], do: Map.put(acc, color, int), else: acc
    end)
  end

  defp game_valid(str) do
    ["Game " <> game_id, set_str] = String.split(str, ": ")
    sets = String.split(set_str, "; ")

    case Enum.all?(sets, &valid_set?/1) do
      true -> {:ok, String.to_integer(game_id)}
      false -> :error
    end
  end

  defp valid_set?(set) do
    # "7 green, 20 blue, 9 red"
    set
    |> String.split(", ")
    |> Enum.all?(&valid_cube_count?/1)
  end

  defp valid_cube_count?(cube) do
    [count, color] = String.split(cube, " ")
    @bag[color] >= String.to_integer(count)
  end
end
