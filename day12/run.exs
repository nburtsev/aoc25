Code.require_file("util.exs")

defmodule Aoc do
  def part1(path) do
    {:ok, contents} = File.read(path)

    input =
      String.split(contents, "\n\n", trim: true)

    {shapes, regions} = input |> Enum.split(6)

    parsed_shapes =
      shapes
      |> Enum.map(fn shape ->
        [_ | s] = String.split(shape, "\n", trim: true)
        s |> Enum.join("")
      end)

    parsed_regions =
      regions
      |> Enum.at(0)
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [size | shapes] = String.split(line, ": ")

        {size_x, size_y} =
          String.split(size, "x") |> Enum.map(&String.to_integer/1) |> List.to_tuple()

        shapes_list = shapes |> Enum.at(0) |> String.split(" ") |> Enum.map(&String.to_integer/1)

        {{size_x, size_y}, shapes_list}
      end)

    parsed_regions
    |> Enum.map(fn {{size_x, size_y}, shapes_list} ->
      area = size_x * size_y

      total_shape_area =
        shapes_list
        |> Enum.with_index()
        |> Enum.map(fn {count, shape_idx} ->
          Enum.at(parsed_shapes, shape_idx)
          |> String.graphemes()
          |> Enum.sum_by(fn x ->
            cond do
              x == "#" -> 1
              true -> 0
            end
          end)
          |> Kernel.*(count)
        end)
        |> Enum.sum()

      area_sufficient = area >= total_shape_area

      num_3x3_subareas = div(size_x, 3) * div(size_y, 3)
      enough_subareas = num_3x3_subareas >= length(shapes_list)

      area_sufficient and enough_subareas
    end)
    |> Enum.count(& &1)
    |> IO.inspect()
  end
end

IO.puts("--- Part 1 ---")

# not quite sure whats more annoying, the fact that this is the solution or what the solution would be if this was not the solution
Aoc.part1(Path.join(__DIR__, "input.txt"))
