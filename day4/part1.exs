defmodule Aoc do
  def solution(path) do
    {:ok, contents} = File.read(path)

    roll = "@"

    grid = contents |> String.split("\n", trim: true) |> Enum.map(&String.graphemes/1)

    grid
    |> Enum.with_index()
    # |> IO.inspect()
    |> Enum.map(fn {row, row_index} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {cell, col_index} ->
        cond do
          cell == roll ->
            neighbors(grid, row_index, col_index) |> Enum.count(fn n -> n == roll end)

          true ->
            -1
        end
      end)
    end)
    |> Enum.map(fn row ->
      row |> Enum.count(fn x -> x >= 0 and x < 4 end)
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  def print_grid(grid) do
    grid
    |> Enum.each(fn row ->
      row
      |> Enum.join("")
      |> IO.puts()
    end)
  end

  def get_from_grid(grid, row, col) do
    cond do
      row < 0 ->
        nil

      col < 0 ->
        nil

      row >= length(grid) ->
        nil

      col >= length(Enum.at(grid, 0)) ->
        nil

      true ->
        grid
        |> Enum.at(row)
        |> Enum.at(col)
    end
  end

  def neighbors(grid, row, col) do
    [
      # up
      get_from_grid(grid, row - 1, col),
      # down
      get_from_grid(grid, row + 1, col),
      # left
      get_from_grid(grid, row, col - 1),
      # right
      get_from_grid(grid, row, col + 1),
      # up-left
      get_from_grid(grid, row - 1, col - 1),
      # up-right
      get_from_grid(grid, row - 1, col + 1),
      # down-left
      get_from_grid(grid, row + 1, col - 1),
      # down-right
      get_from_grid(grid, row + 1, col + 1)
    ]
    # remove nils
    |> Enum.filter(& &1)
  end
end

Aoc.solution("input_test.txt")
Aoc.solution("input.txt")
