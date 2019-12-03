defmodule Intcode do
  # Opcode 1 adds together numbers from 2 positions
  # eg 1, 10, 20, 30 -> adds nums at pos 10 and 20 and puts in 30 position
  # Opcode 2 multiplies

  def find_inputs(output, code) do
    Enum.each(0..99, fn i ->
      Enum.each(0..99, fn j ->
        case get_zero_value(code, i, j) do
          ^output -> IO.inspect({i, j})
          _ -> :noop
        end
      end)
    end)
  end

  def get_zero_value(code, i, j) do
    code
    |> List.replace_at(1, i)
    |> List.replace_at(2, j)
    |> read_all()
    |> List.first()
  end

  def read_all(code) do
    last_index = Enum.count(code) - 1

    Enum.reduce(0..last_index, code, fn index, acc ->
      case rem(index, 4) do
        0 -> read(index, acc)
        _ -> acc
      end
    end)
  end

  def read(index, code) do
    operation = Enum.at(code, index)

    case operation do
      99 ->
        code

      _ ->
        index1 = Enum.at(code, index + 1)
        index2 = Enum.at(code, index + 2)
        result_index = Enum.at(code, index + 3)

        work(code, operation, {index1, index2, result_index})
    end
  end

  def work(code, 1, {index1, index2, pos_index}) do
    case get_values(code, index1, index2) do
      {nil, _} -> code
      {_, nil} -> code
      {val1, val2} -> List.replace_at(code, pos_index, val1 + val2)
    end
  end

  def work(code, 2, {index1, index2, pos_index}) do
    case get_values(code, index1, index2) do
      {nil, _} -> code
      {_, nil} -> code
      {val1, val2} -> List.replace_at(code, pos_index, val1 * val2)
    end
  end

  def work(code, _op, _indexes), do: code

  def get_values(code, index1, index2) do
    {Enum.at(code, index1), Enum.at(code, index2)}
  end
end
