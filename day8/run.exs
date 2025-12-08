Code.require_file("util.exs")

defmodule Aoc do
  def read_boxes(path) do
    Util.read_lines(path)
    |> Enum.map(&String.split(&1, ",", trim: true))
    |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end))
    |> Enum.map(fn box -> [box] end)
  end

  def distance_map(boxes) do
    0..(length(boxes) - 1)
    |> Enum.reduce(%{}, fn i, acc ->
      [box1] = Enum.at(boxes, i)

      i..(length(boxes) - 1)
      |> Enum.reduce(acc, fn j, acc2 ->
        [box2] = Enum.at(boxes, j)

        dist = distance(box1, box2)

        if dist == 0 do
          acc2
        else
          Map.put(acc2, {box1, box2}, dist)
        end
      end)
    end)
    |> Enum.sort(fn {_k1, v1}, {_k2, v2} -> v1 < v2 end)
  end

  def in_circuit?(box, circuit) do
    Enum.any?(circuit, fn b -> b == box end)
  end

  def distance([x1, y1, z1], [x2, y2, z2]) do
    :math.sqrt(
      :math.pow(x2 - x1, 2) +
        :math.pow(y2 - y1, 2) +
        :math.pow(z2 - z1, 2)
    )
  end

  def add_circuit(distance_elem, circuits) do
    {{box1, box2}, _} = distance_elem

    existing_circuits =
      Enum.filter(circuits, fn x -> in_circuit?(box1, x) or in_circuit?(box2, x) end)

    merged_circuits =
      existing_circuits
      |> Enum.flat_map(fn x -> x end)
      |> Enum.uniq()

    {Enum.reject(circuits, fn x -> in_circuit?(box1, x) or in_circuit?(box2, x) end) ++
       [merged_circuits], box1, box2}
  end

  def part1(path, iterations) do
    boxes = read_boxes(path)
    distances = distance_map(boxes)

    0..(iterations - 1)

    distances
    |> Enum.slice(0..(iterations - 1))
    |> Enum.reduce(boxes, fn distance, acc ->
      {new_acc, _, _} = add_circuit(distance, acc)
      new_acc
    end)
    |> Enum.sort(fn a, b -> length(a) > length(b) end)
    |> Enum.slice(0..2)
    |> Enum.reduce(1, fn circuit, acc -> acc * length(circuit) end)
    |> IO.inspect()
  end

  def part2(path) do
    boxes = read_boxes(path)
    distances = distance_map(boxes)

    distances
    |> Enum.reduce_while(boxes, fn x, acc ->
      {new_acc, [x1, _, _], [x2, _, _]} = add_circuit(x, acc)

      cond do
        length(new_acc) == 1 ->
          {:halt, x1 * x2}

        true ->
          {:cont, new_acc}
      end
    end)
    |> IO.inspect()
  end
end

IO.puts("--- Part 1 ---")
Aoc.part1(Path.join(__DIR__, "input_test.txt"), 10)
Aoc.part1(Path.join(__DIR__, "input.txt"), 1000)

IO.puts("--- Part 2 ---")
Aoc.part2(Path.join(__DIR__, "input_test.txt"))
Aoc.part2(Path.join(__DIR__, "input.txt"))
