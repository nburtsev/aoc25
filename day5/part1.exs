defmodule Aoc do
  def solution(path) do
    {:ok, contents} = File.read(path)

    [fresh, ingredients] =
      contents
      |> String.split("\n\n")
      |> Enum.map(&String.split(&1, "\n", trim: true))

    ranges =
      fresh
      |> Enum.map(fn line ->
        line |> String.split("-") |> Enum.map(&String.to_integer/1)
      end)

    ingredients
    |> Enum.map(&String.to_integer/1)
    |> Enum.filter(fn ingredient ->
      Enum.any?(ranges, fn [low, high] -> ingredient >= low and ingredient <= high end)
    end)
    |> Enum.count()
    |> IO.inspect()
  end
end

Aoc.solution("input_test.txt")
Aoc.solution("input.txt")
