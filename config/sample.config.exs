import Config

config :advent_of_code_utils,
  auto_compile?: true,
  time_calls?: true,
  gen_tests?: true,
  session: "<session cookie value from Advent of Code>"

config :iex,
  inspect: [charlists: :as_lists]
