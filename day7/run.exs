Code.require_file("util.exs")

defmodule Aoc do
  def part1(path) do
    {_, _, edges} = parse_tree(path)

    edges
    |> Map.values()
    |> Enum.flat_map(& &1)
    |> Enum.uniq()
    |> length()
    |> IO.inspect()
  end

  def part2(path) do
    {start_col, _, edges} = parse_tree(path)

    count_paths([3, start_col], edges, %{})
    |> elem(0)
    |> IO.inspect()
  end

  def count_paths(node, edges, memo) do
    if Map.has_key?(memo, node) do
      {Map.get(memo, node), memo}
    else
      children = Map.get(edges, node, [])

      if children == [] do
        {1, Map.put(memo, node, 1)}
      else
        {total, updated_memo} =
          Enum.reduce(children, {0, memo}, fn child, {count, m} ->
            {child_count, new_m} = count_paths(child, edges, m)
            {count + child_count, new_m}
          end)

        {total, Map.put(updated_memo, node, total)}
      end
    end
  end

  def parse_tree(path) do
    lines = Util.read_lines(path)

    [first | rest] = lines

    start_col = first |> String.graphemes() |> Enum.find_index(fn p -> p == "S" end)

    splitters =
      rest
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(fn line -> Enum.with_index(line) end)
      |> Enum.map(fn line -> Enum.filter(line, fn {p, _i} -> p != "." end) end)
      |> Enum.with_index(2)
      |> Enum.filter(fn {line, _} -> length(line) > 0 end)
      |> Enum.flat_map(fn {line, row} ->
        Enum.map(line, fn {_, col} ->
          [row, col]
        end)
      end)

    edges =
      splitters
      |> Enum.reduce(%{}, fn splitter, acc ->
        left =
          Enum.filter(splitters, fn [r, c] ->
            [rs, cs] = splitter
            c == cs - 1 and r > rs
          end)

        right =
          Enum.filter(splitters, fn [r, c] ->
            [rs, cs] = splitter
            c == cs + 1 and r > rs
          end)

        t = [Enum.at(left, 0), Enum.at(right, 0)]

        Map.put(acc, splitter, t)
      end)

    {start_col, splitters, edges}
  end
end

IO.puts("--- Part 1 ---")
Aoc.part1(Path.join(__DIR__, "input_test.txt"))
Aoc.part1(Path.join(__DIR__, "input.txt"))

IO.puts("--- Part 2 ---")
Aoc.part2(Path.join(__DIR__, "input_test.txt"))
Aoc.part2(Path.join(__DIR__, "input.txt"))
