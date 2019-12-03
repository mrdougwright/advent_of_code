defmodule Matrix do
  def new(size) do
    row = List.duplicate(0, size)
    List.duplicate(row, size)
  end

  def make_grid(x, y, marks) do
    Enum.reduce(marks, {new(x * y), {y, 0}}, fn mark, acc ->
      grid = elem(acc, 0)
      ep = elem(acc, 1)
      move(grid, ep, mark)
    end)
  end

  def move(matrix, {row, col} = point, "R" <> num) do
    {marked_grid, end_point} = walk(matrix, point, num, &move_right/3)
    {marked_grid, {row, col + end_point}}
  end

  def move(matrix, {row, col} = point, "L" <> num) do
    {marked_grid, end_point} = walk(matrix, point, num, &move_left/3)
    {marked_grid, {row, col - end_point}}
  end

  def move(matrix, {row, col} = point, "U" <> num) do
    {marked_grid, end_point} = walk(matrix, point, num, &move_up/3)
    {marked_grid, {row - end_point, col}}
  end

  def move(matrix, {row, col} = point, "D" <> num) do
    {marked_grid, end_point} = walk(matrix, point, num, &move_down/3)
    {marked_grid, {row + end_point, col}}
  end

  def walk(matrix, {row, col}, num, func) do
    end_point = String.to_integer(num)

    grid =
      Enum.reduce(1..end_point, matrix, fn i, acc ->
        func.(acc, {row, col}, i)
      end)

    {grid, end_point}
  end

  def move_left(matrix, {row, col}, step) do
    mark(matrix, {row, col - step})
  end

  def move_right(matrix, {row, col}, step) do
    mark(matrix, {row, col + step})
  end

  def move_up(matrix, {row, col}, step) do
    mark(matrix, {row - step, col})
  end

  def move_down(matrix, {row, col}, step) do
    mark(matrix, {row + step, col})
  end

  def mark(matrix, {row, col}) do
    val =
      matrix
      |> Enum.at(row)
      |> Enum.at(col)

    new_row =
      matrix
      |> Enum.at(row)
      |> List.replace_at(col, val + 1)

    List.replace_at(matrix, row, new_row)
  end
end
