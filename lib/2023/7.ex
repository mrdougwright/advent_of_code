import AOC

aoc 2023, 7 do
  @moduledoc """
  https://adventofcode.com/2023/day/7
  """
  @val_map %{"A" => 14, "K" => 13, "Q" => 12, "J" => 1, "T" => 10}
  @rank %{
    five_kind: 7,
    four_kind: 6,
    full_house: 5,
    three_kind: 4,
    two_pair: 3,
    pair: 2,
    high_card: 1
  }

  def p1(input) do
    input
    |> Helpers.read()
    |> clean()
    |> Enum.map(&add_worth/1)
    |> rank_cards()
  end

  def p2(input) do
    input
    |> Helpers.read()
    |> clean()
    |> Enum.map(&add_worth_w_joker/1)
    |> rank_cards()
  end

  def rank_cards(cards) do
    cards
    |> Enum.sort(&sorter(&2, &1))
    |> Enum.with_index()
    |> Enum.map(fn {{_hand, bid, _rank}, idx} -> bid * (idx + 1) end)
    |> Enum.sum()
  end

  def sorter({hand1, _, r1}, {hand2, _, r2}) do
    h1 = get_hand(r1) |> get_value()
    h2 = get_hand(r2) |> get_value()

    cond do
      h1 > h2 ->
        true

      h2 > h1 ->
        false

      h1 == h2 ->
        hand1 = String.split(hand1, "", trim: true)
        hand2 = String.split(hand2, "", trim: true)
        tie_breaker(hand1, hand2)
    end
  end

  def tie_breaker([], []), do: false

  def tie_breaker([c1 | rest1], [c2 | rest2]) do
    if c1 == c2, do: tie_breaker(rest1, rest2), else: greater_card?(c1, c2)
  end

  def get_value(atom), do: Map.get(@rank, atom)

  def get_hand([{_, 5}]), do: :five_kind
  def get_hand([{_, 4}]), do: :four_kind
  def get_hand([{_, 3}, {_, 2}]), do: :full_house
  def get_hand([{_, 2}, {_, 3}]), do: :full_house
  def get_hand([{_, 3}]), do: :three_kind
  def get_hand([{_, 2}, {_, 2}]), do: :two_pair
  def get_hand([{_, 2}]), do: :pair
  def get_hand([]), do: :high_card

  def greater_card?(c1, c2) do
    v1 = @val_map[c1] || String.to_integer(c1)
    v2 = @val_map[c2] || String.to_integer(c2)
    v1 >= v2
  end

  def add_worth({hand, value}) do
    worth =
      hand
      |> String.split("", trim: true)
      |> Enum.reduce(%{}, &update_map(&1, &2))
      |> Enum.reject(fn {_k, v} -> v == 1 end)

    {hand, value, worth}
  end

  def add_worth_w_joker({hand, value}) do
    worth =
      hand
      |> String.split("", trim: true)
      |> Enum.reduce(%{}, &update_map(&1, &2))
      |> best_with_joker()
      |> Enum.reject(fn {_k, v} -> v == 1 end)

    {hand, value, worth}
  end

  def update_map(card, map) do
    case map[card] do
      nil -> Map.put(map, card, 1)
      val -> Map.put(map, card, val + 1)
    end
  end

  def best_with_joker(%{"J" => count} = map) do
    map = Map.drop(map, ["J"])

    if map == %{} do
      %{"A" => 5}
    else
      {highest, _value} =
        Enum.reduce(map, fn {k, v}, acc ->
          if elem(acc, 1) >= v, do: acc, else: {k, v}
        end)

      old_val = Map.get(map, highest)
      Map.put(map, highest, old_val + count)
    end
  end

  def best_with_joker(map), do: map

  def clean(lines) do
    Enum.map(lines, fn cv ->
      [card, val] = String.split(cv, " ")
      {card, String.to_integer(val)}
    end)
  end
end
