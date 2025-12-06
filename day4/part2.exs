defmodule Aoc do
  @roll "@"
  @max_neighbors 4

  def solution(path) do
    {:ok, contents} = File.read(path)

    grid = contents |> String.split("\n", trim: true) |> Enum.map(&String.graphemes/1)

    final_grid =
      Stream.iterate(grid, fn g -> find_and_remove(g) end)
      |> Enum.find(fn g -> not can_continue_removing?(g) end)

    # |> IO.inspect()

    (count_rolls(grid) - count_rolls(final_grid)) |> IO.inspect()
  end

  def print_grid(grid) do
    grid
    |> Enum.each(fn row ->
      row
      |> Enum.join("")
      |> IO.puts()
    end)
  end

  def can_be_removed(grid, row, col) do
    neighbor_rolls =
      neighbors(grid, row, col)
      |> Enum.filter(fn n -> n == @roll end)
      |> length()

    neighbor_rolls < @max_neighbors
  end

  def count_rolls(grid) do
    grid
    |> Enum.flat_map(fn row -> row end)
    |> Enum.filter(fn cell -> cell == @roll end)
    |> length()
  end

  def find_and_remove(grid) do
    removeable_positions = find_removable_positions(grid)

    Enum.reduce(removeable_positions, grid, fn {row, col}, acc ->
      remove_from_grid(acc, row, col)
    end)
  end

  def can_continue_removing?(grid) do
    find_removable_positions(grid) |> length() |> Kernel.>(0)
  end

  def find_removable_positions(grid) do
    grid
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_index} ->
      row
      |> Enum.with_index()
      |> Enum.filter(fn {cell, col_index} ->
        cell == @roll and can_be_removed(grid, row_index, col_index)
      end)
      |> Enum.map(fn {_cell, col_index} -> {row_index, col_index} end)
    end)
  end

  def remove_from_grid(grid, row, col) do
    List.update_at(grid, row, fn r ->
      List.update_at(r, col, fn _ -> "." end)
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
