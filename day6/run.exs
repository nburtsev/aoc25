Code.require_file("util.exs")

defmodule Aoc do
  def part1(path) do
    Util.read_lines(path)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.reverse()
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    # |> IO.inspect()
    |> Enum.map(fn [op_symbol | args] ->
      {op, acc} =
        case op_symbol do
          "*" -> {&*/2, 1}
          "+" -> {&+/2, 0}
        end

      args |> Enum.map(&String.to_integer/1) |> Enum.reduce(acc, op)
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  def part2(path) do
    {:ok, contents} = File.read(path)

    [ops | args] =
      contents
      |> String.split("\n", trim: true)
      |> Enum.reverse()

    parsed_args =
      args
      |> Enum.map(&String.graphemes/1)
      |> Enum.reverse()
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&Enum.join/1)
      |> Enum.map(&String.trim/1)
      |> Enum.chunk_by(fn x -> x == "" end)
      |> Enum.filter(fn x -> x != [""] end)
      |> Enum.map(fn args ->
        Enum.map(args, &String.to_integer/1)
      end)

    ops
    |> String.split(" ", trim: true)
    |> Enum.zip(parsed_args)
    |> Enum.map(fn {op_symbol, args} ->
      {op, acc} =
        case op_symbol do
          "*" -> {&*/2, 1}
          "+" -> {&+/2, 0}
        end

      args |> Enum.reduce(acc, op)
    end)
    |> Enum.sum()
    |> IO.inspect()
  end
end

IO.puts("--- Part 1 ---")
Aoc.part1(Path.join(__DIR__, "input_test.txt"))
Aoc.part1(Path.join(__DIR__, "input.txt"))

IO.puts("--- Part 2 ---")
Aoc.part2(Path.join(__DIR__, "input_test.txt"))
Aoc.part2(Path.join(__DIR__, "input.txt"))
