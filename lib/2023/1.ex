import AOC

aoc 2023, 1 do
  @moduledoc """
  https://adventofcode.com/2023/day/1
  """
  @word_ints %{
    "0" => "0",
    "1" => "1",
    "2" => "2",
    "3" => "3",
    "4" => "4",
    "5" => "5",
    "6" => "6",
    "7" => "7",
    "8" => "8",
    "9" => "9",
    "eight" => "8",
    "five" => "5",
    "four" => "4",
    "nine" => "9",
    "one" => "1",
    "seven" => "7",
    "six" => "6",
    "three" => "3",
    "two" => "2",
    "zero" => "0"
  }

  # calibration_values are a list of lines from text input file
  def p1(calibration_values) do
    Enum.reduce(calibration_values, 0, fn str, acc ->
      int = get_int(str) <> get_int(String.reverse(str))
      acc + String.to_integer(int)
    end)
  end

  def p2(values) do
    values =
      Enum.map(values, fn str ->
        get_int_value(str) <> get_int_value_reverse(str)
      end)

    p1(values)
  end

  def get_int_value_reverse(str) do
    str
    |> String.reverse()
    |> String.split("")
    |> Enum.reduce_while("", fn x, acc ->
      case contains_num(acc) do
        {:ok, num} -> {:halt, num}
        :error -> {:cont, x <> acc}
      end
    end)
  end

  def get_int_value(str) do
    str
    |> String.split("")
    |> Enum.reduce_while("", fn x, acc ->
      case contains_num(acc) do
        {:ok, num} -> {:halt, num}
        :error -> {:cont, acc <> x}
      end
    end)
  end

  def contains_num(str) do
    case Enum.find(@word_ints, fn {word, _int} -> String.contains?(str, word) end) do
      nil -> :error
      {_word, int} -> {:ok, int}
    end
  end

  defp get_int(str) do
    str
    |> String.split("", trim: true)
    |> Enum.filter(&("0" <= &1 and &1 <= "9"))
    |> List.first()
  end
end
