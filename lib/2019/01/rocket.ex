defmodule Rocket do
  def count_fuel(module) do
    Kernel.floor(module / 3) - 2
  end

  def total_fuel_req(modules) do
    Enum.reduce(modules, 0, fn fuel, acc -> acc + count_fuel(fuel) end)
  end
end
