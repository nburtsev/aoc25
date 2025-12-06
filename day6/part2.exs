defmodule Aoc do
  def solution(path) do
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

Aoc.solution("input_test.txt")
Aoc.solution("input.txt")
