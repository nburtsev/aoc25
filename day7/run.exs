Code.require_file("util.exs")

defmodule Aoc do
  def part1(path) do
    [start | rest] = Util.read_lines(path)

    beams = [start |> String.graphemes() |> Enum.find_index(fn p -> p == "S" end)]

    splitters =
      rest
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(fn line -> Enum.with_index(line) end)
      |> Enum.map(fn line -> Enum.filter(line, fn {p, _i} -> p != "." end) end)

    splitters
    |> Enum.reduce({beams, 0}, fn line, acc ->
      {b, c} = acc

      new_beams =
        Enum.flat_map(b, fn beam ->
          cond do
            Enum.any?(line, fn {_, i} -> i == beam end) ->
              [beam - 1, beam + 1]

            true ->
              [beam]
          end
        end)
        |> Enum.uniq()

      splitters_hit =
        Enum.map(b, fn beam ->
          if Enum.any?(line, fn {_, i} -> i == beam end) do
            1
          else
            0
          end
        end)
        |> Enum.sum()

      {new_beams, c + splitters_hit}
    end)
    |> elem(1)
    |> IO.inspect()
  end

  # brute force did not work, the thing is a graph, need to parse it as a graph and do dfs or something
  def part2(path) do
  end
end

IO.puts("--- Part 1 ---")
Aoc.part1(Path.join(__DIR__, "input_test.txt"))
Aoc.part1(Path.join(__DIR__, "input.txt"))

# IO.puts("--- Part 2 ---")
# Aoc.part2(Path.join(__DIR__, "input_test.txt"))
# Aoc.part2(Path.join(__DIR__, "input.txt"))
