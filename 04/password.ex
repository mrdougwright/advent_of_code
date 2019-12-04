defmodule Password do
  def count_possible(range) do
    range
    |> Enum.to_list()
    |> Enum.filter(fn num ->
      only_increases?(num) && contains_double?(num)
    end)
    |> Enum.reject(&has_larger_group?/1)
    |> Enum.count()
  end

  def has_larger_group?(number) do
    number
    |> split_number()
    |> larger_group?
  end

  def only_increases?(number) do
    number
    |> split_number()
    |> Enum.map(&String.to_integer/1)
    |> only_increasing?()
  end

  def only_increasing?([a, b]), do: b >= a

  def only_increasing?([a, b | rest]) do
    case b >= a do
      true -> only_increasing?([b] ++ rest)
      false -> false
    end
  end

  def contains_double?(number) do
    number
    |> split_number()
    |> same_adjacent?()
  end

  def same_adjacent?([num, num | _rest]), do: true
  def same_adjacent?([_a, b | rest]), do: same_adjacent?([b] ++ rest)
  def same_adjacent?(_), do: false

  def larger_group?(numbers) do
    numbers
    |> Enum.reduce(%{}, fn x, acc ->
      Map.update(acc, x, 1, &(&1 + 1))
    end)
    |> Map.values()
    |> Enum.all?(&(&1 != 2))
  end

  def split_number(num) do
    num
    |> Integer.to_string()
    |> String.split("", trim: true)
  end
end
