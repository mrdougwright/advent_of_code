import AOC

aoc 2023, 6 do
  @moduledoc """
  https://adventofcode.com/2023/day/6
  """

  def p1(input) do
    data = input |> read() |> clean()

    Enum.reduce(data, 1, fn {time, dist}, acc ->
      win_count(time, dist) * acc
    end)
  end

  def p2(input) do
    {time, dist} = input |> read() |> clean2()
    win_count(time, dist)
  end

  def win_count(time, dist) do
    Enum.reduce(1..time, 0, fn btn_press, acc ->
      if distance_traveled(btn_press, time) > dist, do: acc + 1, else: acc
    end)
  end

  def distance_traveled(btn_press, time), do: btn_press * (time - btn_press)

  def read(input) when is_binary(input) do
    String.split(input, "\n", trim: true)
  end

  def clean(data) do
    ["Time:" <> time, "Distance:" <> distance] = data

    [split_get_int(time), split_get_int(distance)]
    |> Enum.zip()
  end

  def clean2(data) do
    ["Time:" <> time, "Distance:" <> distance] = data

    {get_int(time), get_int(distance)}
  end

  def split_get_int(data) do
    data |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
  end

  def get_int(data) do
    data |> String.split(" ", trim: true) |> List.to_string() |> String.to_integer()
  end
end
