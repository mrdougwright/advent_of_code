defmodule Helpers do
  def read(input) when is_binary(input) do
    String.split(input, "\n", trim: true)
  end
end
