Code.require_file("util.exs")

defmodule Aoc do
  def part1(path) do
    nodes = parse(path)

    count_paths(nodes, "you", "out", %{})
    |> elem(0)
    |> IO.inspect()
  end

  def parse(path) do
    Util.read_lines(path)
    |> Enum.map(&Regex.scan(~r/[a-z]+/, &1))
    |> Enum.reduce(%{}, fn l, acc ->
      [source | destinations] = Enum.map(l, fn [x] -> x end)
      Map.put(acc, source, destinations)
    end)
  end

  def count_paths(nodes, current, finish, memo) do
    if Map.has_key?(memo, current) do
      {Map.get(memo, current), memo}
    else
      if current == finish do
        {1, Map.put(memo, current, 1)}
      else
        outputs = Map.get(nodes, current, [])

        {total, updated_memo} =
          Enum.reduce(outputs, {0, memo}, fn child, {acc, m} ->
            {c, new_memo} = count_paths(nodes, child, finish, m)
            {acc + c, new_memo}
          end)

        {total, Map.put(updated_memo, current, total)}
      end
    end
  end

  def part2(path) do
    nodes = parse(path)
    {c1, _} = count_paths(nodes, "svr", "dac", %{})
    {c2, _} = count_paths(nodes, "dac", "fft", %{})
    {c3, _} = count_paths(nodes, "fft", "out", %{})
    {c4, _} = count_paths(nodes, "svr", "fft", %{})
    {c5, _} = count_paths(nodes, "fft", "dac", %{})
    {c6, _} = count_paths(nodes, "dac", "out", %{})

    IO.inspect(c1 * c2 * c3 + c4 * c5 * c6)
  end
end

IO.puts("--- Part 1 ---")
Aoc.part1(Path.join(__DIR__, "input_test.txt"))
Aoc.part1(Path.join(__DIR__, "input.txt"))

IO.puts("--- Part 2 ---")
Aoc.part2(Path.join(__DIR__, "input_test2.txt"))
Aoc.part2(Path.join(__DIR__, "input.txt"))
