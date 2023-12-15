import AOC

aoc 2023, 15 do
  @moduledoc """
  https://adventofcode.com/2023/day/15
  """

  def p1(input) do
    input
    |> clean()
    |> Enum.map(&to_charlist/1)
    |> Enum.map(&hash(&1, 0))
    |> Enum.sum()
  end

  def p2(input) do
    light_boxes = List.duplicate([], 256)

    input
    |> clean()
    |> Enum.reduce(light_boxes, fn str, acc -> add_or_remove_lens(acc, str) end)
    |> Enum.with_index()
    |> Enum.map(&focus_power/1)
    |> Enum.sum()
  end

  def focus_power({box, idx}) do
    box_num = idx + 1

    box
    |> Enum.with_index()
    |> Enum.reduce(0, fn {{_label, focal_length}, i}, acc ->
      box_num * (i + 1) * focal_length + acc
    end)
  end

  def add_or_remove_lens(light_boxes, str) do
    case String.last(str) do
      "-" -> remove_lens(light_boxes, str)
      _ -> insert_lens(light_boxes, str)
    end
  end

  def remove_lens(light_boxes, str) do
    label = String.trim_trailing(str, "-")
    idx = lidx(label)

    box =
      light_boxes
      |> Enum.at(idx)
      |> List.keydelete(label, 0)

    List.replace_at(light_boxes, idx, box)
  end

  def insert_lens(light_boxes, str) do
    [label, focal_length] = String.split(str, "=")
    lens = {label, String.to_integer(focal_length)}
    idx = lidx(label)

    box = Enum.at(light_boxes, idx)

    box =
      case List.keyfind(box, label, 0) do
        nil -> box ++ [lens]
        _val -> List.keyreplace(box, label, 0, lens)
      end

    List.replace_at(light_boxes, idx, box)
  end

  def hash([], val), do: val
  def hash([ascii | rest], val), do: hash(rest, rem((val + ascii) * 17, 256))

  def lidx(label), do: label |> to_charlist() |> hash(0)

  def clean(input) do
    input
    |> String.trim("\n")
    |> String.split(",", trim: true)
  end
end
