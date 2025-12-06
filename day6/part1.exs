defmodule Aoc do
  def solution(path) do
    {:ok, contents} = File.read(path)

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.reverse()
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> IO.inspect()
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
end

Aoc.solution("input_test.txt")
Aoc.solution("input.txt")
