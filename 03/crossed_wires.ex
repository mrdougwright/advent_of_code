defmodule Matrix do
  def closest_point(wire1, wire2) do
    map1 = lay_wires(wire1)
    map2 = lay_wires(wire2)

    intersections(map1, map2)
    |> Enum.map(&distance/1)
    |> Enum.min()
  end

  def intersections(map1, map2) do
    map1
    |> MapSet.intersection(map2)
    |> MapSet.to_list()
    |> Enum.reject(fn point -> point == {0, 0} end)
  end

  def lay_wires(directions) do
    initial = {{0, 0}, []}

    {end_point, wires} =
      Enum.reduce(directions, initial, fn dir, {from, list} ->
        new_list = lay_wire(list, from, dir)
        last_point = get_last_point(new_list)
        {last_point, new_list}
      end)

    MapSet.new(wires)
  end

  def get_last_point(list) do
    list |> Enum.reverse() |> List.first()
  end

  def distance({x, y}) do
    abs(x) + abs(y)
  end

  def lay_wire(list, {x, y}, direction) do
    {func, steps} = decode(direction)
    count = String.to_integer(steps)

    Enum.reduce(0..count, list, fn i, acc ->
      func.(acc, {x, y}, i)
    end)
  end

  def move_left(list, {x, y}, step) do
    list ++ [{x - step, y}]
  end

  def move_right(list, {x, y}, step) do
    list ++ [{x + step, y}]
  end

  def move_up(list, {x, y}, step) do
    list ++ [{x, y + step}]
  end

  def move_down(list, {x, y}, step) do
    list ++ [{x, y - step}]
  end

  def decode("L" <> steps), do: {&move_left/3, steps}
  def decode("R" <> steps), do: {&move_right/3, steps}
  def decode("U" <> steps), do: {&move_up/3, steps}
  def decode("D" <> steps), do: {&move_down/3, steps}
end
