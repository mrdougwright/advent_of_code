defmodule Matrix do
  # R2, D3, L1, U2
  # --|
  # | |
  # |-|

  def new(size) do
    row = List.duplicate(0, size)
    List.duplicate(row, size)
  end

  def move(matrix, {row, col}, "R" <> num) do
    end_point = String.to_integer(num)

    marked_grid =
      Enum.reduce(1..end_point, matrix, fn i, acc ->
        moving_index = col + i
        mark(acc, {row, moving_index})
      end)

    [marked_grid, {row, col + end_point}]
  end

  def move(matrix, {row, col}, "L" <> num) do
    end_point = String.to_integer(num)

    marked_grid =
      Enum.reduce(1..end_point, matrix, fn i, acc ->
        moving_index = col - i
        mark(acc, {row, moving_index})
      end)

    [marked_grid, {row, col - end_point}]
  end

  def move(matrix, {row, col}, "U" <> num) do
    end_point = String.to_integer(num)

    marked_grid =
      Enum.reduce(1..end_point, matrix, fn i, acc ->
        moving_index = row - i
        mark(acc, {moving_index, col})
      end)

    [marked_grid, {row - end_point, col}]
  end

  def move(matrix, {row, col}, "D" <> num) do
    end_point = String.to_integer(num)

    marked_grid =
      Enum.reduce(1..end_point, matrix, fn i, acc ->
        moving_index = row + i
        mark(acc, {moving_index, col})
      end)

    [marked_grid, {row + end_point, col}]
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
