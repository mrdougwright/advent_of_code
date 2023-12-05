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
      win_count = win_count({picks, nums})

      acc + @score[win_count]
    end)
  end

  def p2(input) do
    cards = input |> read() |> clean()
    winner_index = make_index_list(cards)

    Enum.reduce(winner_index, 0, fn card_list, acc ->
      acc + count_cards(winner_index, cards)
    end)
  end

  def count_cards(idx_list, [_c | []]), do: 1

  def count_cards(idx_list, [_c | cards]) do
    IO.inspect(idx_list)
    next_index = make_index_list(cards)
    length(idx_list) + count_cards(next_index, cards)
  end

  def make_index_list(cards) do
    cards
    |> Enum.with_index()
    |> Enum.map(fn {card, idx} ->
      count = win_count(card)

      case count do
        0 ->
          []

        n ->
          range = idx + n
          beg = idx + 1
          Enum.to_list(beg..range)
      end
    end)
    |> List.flatten()
  end

  def win_count({picks, nums}) do
    Enum.reduce(picks, 0, fn n, acc ->
      if n in nums, do: acc + 1, else: acc
    end)
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
