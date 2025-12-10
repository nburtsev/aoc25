Code.require_file("util.exs")

defmodule Aoc do
  def part1(path) do
    tiles =
      Util.read_lines(path)
      |> Enum.map(&String.split(&1, ",", trim: true))
      |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end))
      |> Enum.map(&List.to_tuple/1)

    for x <- tiles, y <- tiles, x != y do
      area(x, y)
    end
    |> Enum.max()
    |> IO.inspect()
  end

  def area({x1, y1}, {x2, y2}) do
    (1 + abs(x1 - x2)) * (1 + abs(y1 - y2))
  end

  # nope
  def part2(path) do
  end
end

IO.puts("--- Part 1 ---")
Aoc.part1(Path.join(__DIR__, "input_test.txt"))
Aoc.part1(Path.join(__DIR__, "input.txt"))

# IO.puts("--- Part 2 ---")
# Aoc.part2(Path.join(__DIR__, "input_test.txt"))
# Aoc.part2(Path.join(__DIR__, "input.txt"))
