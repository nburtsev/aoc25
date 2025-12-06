defmodule Aoc do
  def solution(path) do
    {:ok, contents} = File.read(path)

    [fresh, _] =
      contents
      |> String.split("\n\n")
      |> Enum.map(&String.split(&1, "\n", trim: true))

    ranges =
      fresh
      |> Enum.map(fn line ->
        line |> String.split("-") |> Enum.map(&String.to_integer/1)
      end)

    ranges
    |> Enum.sort()
    |> Enum.reduce([], fn [low, high], acc ->
      case acc do
        [] ->
          [[low, high]]

        [[acc_low, acc_high] | rest] ->
          if low <= acc_high + 1 do
            # overlap, merge
            [[acc_low, max(acc_high, high)] | rest]
          else
            # no overlap, add new range
            [[low, high] | acc]
          end
      end
    end)
    |> Enum.map(fn [low, high] -> high - low + 1 end)
    |> Enum.sum()
    |> IO.inspect()
  end
end

Aoc.solution("input_test.txt")
Aoc.solution("input.txt")
