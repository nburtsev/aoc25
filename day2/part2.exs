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
    |> Enum.flat_map(&Enum.filter(&1, fn x -> invalid(x) end))
    |> Enum.sum()
    |> IO.inspect()
  end

  def invalid(x) when x < 10, do: false

  def invalid(a) do
    s = Integer.to_string(a)
    half_length = s |> String.length() |> div(2)

    sizes = Enum.to_list(1..half_length)

    # for each size, we chunk the string, get unique chunks and count them.
    # we get a list of counts of unique chunks for each size
    # if any of them is one than it is invalid number
    sizes_counts =
      sizes
      |> Enum.map(fn n ->
        chunk_string(s, n) |> Enum.uniq() |> length()
      end)

    Enum.any?(sizes_counts, fn count -> count == 1 end)
  end

  def chunk_string(a, n) do
    a |> String.codepoints() |> Enum.chunk_every(n) |> Enum.map(&Enum.join/1)
  end
end

Aoc.solution("input_test.txt")
Aoc.solution("input.txt")
