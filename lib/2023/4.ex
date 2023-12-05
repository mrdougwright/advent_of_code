import AOC

aoc 2023, 4 do
  @moduledoc """
  https://adventofcode.com/2023/day/4
  """
  @score %{
    0 => 0,
    1 => 1,
    2 => 2,
    3 => 4,
    4 => 8,
    5 => 16,
    6 => 32,
    7 => 64,
    8 => 128,
    9 => 256,
    10 => 512
  }

  def p1(input) do
    input
    |> read()
    |> clean()
    |> Enum.reduce(0, fn {picks, nums}, acc ->
      win_count =
        Enum.reduce(picks, 0, fn n, acc2 ->
          if n in nums, do: acc2 + 1, else: acc2
        end)

      IO.inspect(win_count)
      acc + @score[win_count]
    end)
  end

  def p2(input) do
  end

  def read(input) when is_binary(input) do
    String.split(input, "\n", trim: true)
  end

  def read(input), do: input

  def clean(list) do
    Enum.map(list, fn line ->
      [card, picks] = String.split(line, " | ")
      [_card_id, numbers] = String.split(card, ": ")
      {split_to_ints(picks), split_to_ints(numbers)}
    end)
  end

  defp split_to_ints(str) do
    str
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
