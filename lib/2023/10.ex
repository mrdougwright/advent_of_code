import AOC

aoc 2023, 10 do
  @moduledoc """
  https://adventofcode.com/2023/day/10
  """
  @pipe_map %{
    "S" => [:start],
    "-" => [:east, :west],
    "|" => [:north, :south],
    "F" => [:south, :east],
    "7" => [:west, :south],
    "J" => [:north, :west],
    "L" => [:north, :east],
    "." => []
  }

  def p1(input) do
    graph = input |> Helpers.read() |> clean()
    IO.inspect(graph)
    traverse(graph)
  end

  def p2(_input) do
  end

  def traverse(graph) do
    # get start node "S"
    {row_idx, col_idx} = start(graph)

    # hardcode start after S 🫠
    Enum.reduce_while(1..100_000, {graph, :east, {row_idx, col_idx - 1}}, fn n, acc ->
      case next_to(acc) do
        :start -> {:halt, n}
        _ -> {:cont, next_pipe(acc)}
      end
    end)
  end

  def direction(pipe, from_dir) do
    Enum.reject(@pipe_map[pipe], fn dir -> dir == from_dir end)
  end

  def next_to({graph, from, node}) do
    cur_pipe = pipe(graph, node)
    [to] = direction(cur_pipe, from)
    to
  end

  def next_pipe({graph, from, node}) do
    to = next_to({graph, from, node})
    # IO.inspect({from, pipe(graph, node), to})
    next_from = opposite_direction(to)

    next_node = to(to, node)
    # IO.inspect({from, pipe(graph, node), to})

    {graph, next_from, next_node}
  end

  def opposite_direction(:east), do: :west
  def opposite_direction(:west), do: :east
  def opposite_direction(:south), do: :north
  def opposite_direction(:north), do: :south

  # def from(:south, {row_idx, col_idx}), do: {row_idx - 1, col_idx}
  # def from(:west, {row_idx, col_idx}), do: {row_idx, col_idx + 1}
  # def from(:north, {row_idx, col_idx}), do: {row_idx + 1, col_idx}
  # def from(:east, {row_idx, col_idx}), do: {row_idx, col_idx - 1}
  def to(:south, {row_idx, col_idx}), do: {row_idx + 1, col_idx}
  def to(:west, {row_idx, col_idx}), do: {row_idx, col_idx - 1}
  def to(:north, {row_idx, col_idx}), do: {row_idx - 1, col_idx}
  def to(:east, {row_idx, col_idx}), do: {row_idx, col_idx + 1}

  def start(graph) do
    row_idx = Enum.find_index(graph, fn l -> Enum.find(l, fn n -> n == "S" end) end)
    col_idx = Enum.at(graph, row_idx) |> Enum.find_index(fn n -> n == "S" end)
    {row_idx, col_idx}
  end

  def pipe(graph, {row_idx, col_idx}) do
    Enum.at(graph, row_idx) |> Enum.at(col_idx)
  end

  def clean(data) do
    # list of lists
    # [
    #   [".", "_", ".", ".", "."],
    #   ["7", "S", "-", "7", "."],
    #   [".", "|", ".", "|", "."],
    #   [".", "L", "-", "J", "."],
    #   [".", ".", ".", ".", "."]
    # ]
    Enum.map(data, &String.split(&1, "", trim: true))
  end
end
