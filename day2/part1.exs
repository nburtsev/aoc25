defmodule Aoc do
  def solution(path) do
    {:ok, contents} = File.read(path)

    contents
    |> String.split("\n", trim: true)
    |> Enum.at(0)
    |> String.split(",", trim: true)
    |> Enum.map(&String.split(&1, "-", trim: true))
    |> Enum.map(fn [a, b] -> {String.to_integer(a), String.to_integer(b)} end)
    |> Enum.map(fn {a, b} -> Enum.to_list(a..b) end)
    |> Enum.flat_map(&Enum.filter(&1, fn x -> valid(x) end))
    |> Enum.sum()
    |> IO.inspect()
  end

  def valid(a) do
    l = Integer.to_string(a) |> String.length() |> div(2)
    {left, right} = a |> Integer.to_string() |> String.split_at(l)

    cond do
      left == right -> true
      true -> false
    end
  end
end

Aoc.solution("input_test.txt")
Aoc.solution("input.txt")
