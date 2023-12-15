import AOC

aoc 2023, 9 do
  @moduledoc """
  https://adventofcode.com/2023/day/9
  """

  def p1(input) do
    input
    |> Helpers.read()
    |> clean()
    |> Enum.map(&Enum.reverse/1)
    |> list_last_diff_sums()
    |> Enum.sum()
  end

  def list_last_diff_sums(list) do
    Enum.map(list, fn nums ->
      nums
      |> diff_list()
      |> Enum.reduce(0, fn [n | _], acc ->
        n + acc
      end)
    end)
  end

  def diff_list(nums) do
    Enum.reduce_while(1..1_000_000_000_000, [nums], fn _x, acc ->
      seq = make_sequence(List.first(acc))

      case Enum.sum(seq) do
        0 -> {:halt, acc}
        _ -> {:cont, [seq | acc]}
      end
    end)
  end

  def make_sequence([_one | []]), do: []

  def make_sequence([one | rest]) do
    [one - List.first(rest) | make_sequence(rest)]
  end

  def p2(_input) do
  end

  def clean(data), do: Enum.map(data, &to_int/1)
  def to_int(str), do: String.split(str, " ", trim: true) |> Enum.map(&String.to_integer/1)
end
