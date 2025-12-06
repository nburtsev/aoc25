defmodule Aoc do
  def solution(path) do
    {:ok, contents} = File.read(path)

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn chars -> Enum.map(chars, &String.to_integer/1) end)
    |> Enum.map(&to_pairs/1)
    |> Enum.map(&Enum.max/1)
    |> IO.inspect(charlists: :as_lists)
    |> Enum.sum()
    |> IO.inspect()
  end

  # all possible pairs of elements from the list left to right
  def to_pairs(list) do
    for i <- 0..(length(list) - 2),
        j <- (i + 1)..(length(list) - 1),
        do: Enum.at(list, i) * 10 + Enum.at(list, j)
  end
end

Aoc.solution("input_test.txt")
Aoc.solution("input.txt")
