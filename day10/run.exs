Code.require_file("util.exs")
import Bitwise

defmodule Aoc do
  def part1(path) do
    Util.read_lines(path)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(fn line ->
      [lights | rest] = line

      parsed_lights =
        Regex.scan(~r/[#\.]/, lights)
        |> List.flatten()
        |> Enum.map(fn x ->
          cond do
            x == "." -> 0
            true -> 1
          end
        end)

      {_, buttons} = List.pop_at(rest, -1)

      parsed_buttons =
        buttons
        |> Enum.map(fn x ->
          Regex.scan(~r/[0-9]/, x)
          |> List.flatten()
          |> Enum.map(&String.to_integer/1)
        end)
        |> Enum.map(&buttons_to_mask(&1, length(parsed_lights)))

      {parsed_lights, parsed_buttons}
    end)
    |> Enum.map(fn {lights, buttons} ->
      start = 1..length(lights) |> Enum.map(fn _ -> 0 end)
      target = lights
      buttons = buttons

      BFS.bfs(
        start,
        target,
        buttons
      )
    end)
    |> Enum.sum()
    |> IO.inspect(label: "total")
  end

  defp buttons_to_mask(buttons, length) do
    0..(length - 1)
    |> Enum.map(fn i ->
      if Enum.member?(buttons, i), do: 1, else: 0
    end)
  end

  def part2(_path) do
  end
end

defmodule BFS do
  def bfs(start_bits, target_bits, masks_bits) do
    start = bits_to_int(start_bits)
    target = bits_to_int(target_bits)
    masks = Enum.map(masks_bits, &bits_to_int/1)

    if start == target do
      0
    else
      do_bfs(%{start => 0}, %{target => 0}, MapSet.new([start]), MapSet.new([target]), masks)
    end
  end

  defp do_bfs(dist_a, dist_b, front_a, front_b, masks) do
    cond do
      MapSet.size(front_a) == 0 or MapSet.size(front_b) == 0 ->
        nil

      MapSet.size(front_a) <= MapSet.size(front_b) ->
        expand_once(dist_a, dist_b, front_a, front_b, masks, :a)

      true ->
        expand_once(dist_b, dist_a, front_b, front_a, masks, :b)
    end
  end

  defp expand_once(dist_curr, dist_other, frontier, other_frontier, masks, which_side) do
    {new_dist, new_frontier, solution} =
      Enum.reduce(frontier, {dist_curr, MapSet.new(), nil}, fn state, acc ->
        case acc do
          {_dc, _nf, result} when not is_nil(result) ->
            acc

          {dc, nf, nil} ->
            Enum.reduce_while(masks, {dc, nf, nil}, fn mask, {dc, nf, _} ->
              new_state = Bitwise.bxor(state, mask)

              if Map.has_key?(dist_other, new_state) do
                {:halt, {dc, nf, dc[state] + dist_other[new_state] + 1}}
              else
                if Map.has_key?(dc, new_state) do
                  {:cont, {dc, nf, nil}}
                else
                  dc2 = Map.put(dc, new_state, dc[state] + 1)
                  nf2 = MapSet.put(nf, new_state)
                  {:cont, {dc2, nf2, nil}}
                end
              end
            end)
        end
      end)

    if solution do
      solution
    else
      case which_side do
        :a -> do_bfs(new_dist, dist_other, new_frontier, other_frontier, masks)
        :b -> do_bfs(dist_other, new_dist, other_frontier, new_frontier, masks)
      end
    end
  end

  defp bits_to_int(bits) do
    Enum.reduce(bits, 0, fn b, acc -> acc <<< 1 ||| b end)
  end
end

IO.puts("--- Part 1 ---")
Aoc.part1(Path.join(__DIR__, "input_test.txt"))
Aoc.part1(Path.join(__DIR__, "input.txt"))

# hard no
# IO.puts("--- Part 2 ---")
# Aoc.part2(Path.join(__DIR__, "input_test.txt"))
# Aoc.part2(Path.join(__DIR__, "input.txt"))
