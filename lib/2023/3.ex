import AOC

aoc 2023, 3 do
  @moduledoc """
  https://adventofcode.com/2023/day/3
  """

  def p1(input) do
    input = read_input(input)

    Enum.with_index(input, fn line, row_index ->
      Enum.with_index(line, fn char, col_index ->
        if is_symbol?(char) do
          top_line = Enum.at(input, row_index - 1)
          bot_line = Enum.at(input, row_index + 1)

          match_top = match(top_line, col_index)
          match_bot = match(bot_line, col_index)
          match_row = match(line, col_index)

          top_nums = get_nums(top_line, col_index, match_top)
          bot_nums = get_nums(bot_line, col_index, match_bot)
          row_nums = get_nums(line, col_index, match_row)

          top_nums ++ bot_nums ++ row_nums
        else
          []
        end
      end)
      |> Enum.concat()
    end)
    |> Enum.concat()
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def p2(input) do
    Enum.with_index(input, fn line, row_index ->
      Enum.with_index(line, fn char, col_index ->
        if is_gear?(char) do
          top_line = Enum.at(input, row_index - 1)
          bot_line = Enum.at(input, row_index + 1)

          match_top = match(top_line, col_index)
          match_bot = match(bot_line, col_index)
          match_row = match(line, col_index)

          top_nums = get_nums(top_line, col_index, match_top)
          bot_nums = get_nums(bot_line, col_index, match_bot)
          row_nums = get_nums(line, col_index, match_row)

          case get_product(top_nums, row_nums, bot_nums) do
            [_n] -> 0
            [a, b] = nums -> Enum.product(nums)
          end
        end
      end)
      |> Enum.reject(&(&1 == nil))
    end)
    |> Enum.concat()
    |> Enum.sum()
  end

  def read_input(file) do
    file
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def get_product(a, b, c) do
    [a, b, c]
    |> Enum.concat()
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.to_integer/1)
  end

  def match(line, index), do: Enum.slice(line, index - 1, 3)

  def get_nums(_line, _i, [".", ".", "."]), do: []
  def get_nums(_line, _i, [".", char, "."]), do: if(is_int?(char), do: [char], else: [])

  def get_nums(line, i, [_, ".", "."]), do: [num_left(line, i - 1)]
  def get_nums(line, i, [".", ".", _]), do: [num_right(line, i + 1)]

  def get_nums(line, i, [l, c, r]) do
    cond do
      !is_int?(c) ->
        [num_left(line, i - 1), num_right(line, i + 1)]

      is_int?(l) and is_int?(c) and is_int?(r) ->
        [l <> c <> r]

      is_int?(l) and is_int?(c) ->
        [num_left(line, i)]

      is_int?(l) ->
        [num_left(line, i - 1)]

      is_int?(c) and is_int?(r) ->
        [num_right(line, i)]

      true ->
        [num_right(line, i + 1)]
    end
  end

  def num_right(line, i) do
    the_line = Enum.slice(line, i, 150)

    Enum.reduce_while(the_line, "", fn char, acc ->
      if is_int?(char), do: {:cont, acc <> char}, else: {:halt, acc}
    end)
  end

  def num_left(line, i) do
    reverse_index = length(line) - 1
    the_line = line |> Enum.reverse() |> Enum.slice((reverse_index - i)..-1)

    Enum.reduce_while(the_line, "", fn char, acc ->
      if is_int?(char), do: {:cont, char <> acc}, else: {:halt, acc}
    end)
  end

  def is_int?(char) do
    "0" <= char and char <= "9"
  end

  # find non `.` or `\d`
  def is_symbol?("."), do: false
  def is_symbol?(char), do: !is_int?(char)

  def is_gear?("*"), do: true
  def is_gear?(_), do: false
end

# file = File.cwd!() <> "/data/day-03-text.txt"

# file
# |> Day3.read_input()
# |> Day3.p2()
# |> IO.inspect()
