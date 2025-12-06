defmodule Aoc do
  def solution(path) do
    {:ok, contents} = File.read(path)

    contents
    |> String.split("\n", trim: true)
    # |> IO.inspect()
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn chars -> Enum.map(chars, &String.to_integer/1) end)
    |> Enum.map(&to_joltages/1)
    |> Enum.map(&Enum.max/1)
    # |> IO.inspect(charlists: :as_lists)
    |> Enum.sum()
    |> IO.inspect()
  end

  # all possible pairs of elements from the list left to right
  def to_joltages(list) do
    sequence(list, 12)
    |> Enum.map(&Enum.join(&1))
    |> Enum.map(&String.to_integer/1)
  end

  def sequence(_, 0), do: [[]]
  def sequence([], _), do: []

  def sequence(digits, length) do
    [head | tail] = digits

    a =
      for combo <- sequence(tail, length - 1) do
        [head | combo]
      end

    b = sequence(tail, length)

    a ++ b
  end
end

Aoc.solution("input_test.txt")
# recursion is very slow as expected, but works for test inputs, so good enough
# Aoc.solution("input.txt")
