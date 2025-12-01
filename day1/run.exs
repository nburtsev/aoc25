defmodule Day1 do
  def solution(path) do
    {:ok, contents} = File.read(path)

    contents
      |> String.split("\n", trim: true)
      |> Enum.reduce({50, 0}, fn line, {pos, count} ->
        direction = String.at(line, 0)
        steps = String.slice(line, 1..-1//1) |> String.to_integer()
        f = case direction do
          "L" -> &(&1 - &2)
          "R" -> &(&1 + &2)
        end

        actual_steps = rem(steps, 100)
        rotations = div(steps, 100)

        new_pos = f.(pos, actual_steps)

        actual_pos = cond do
          new_pos < 0 -> new_pos + 100
          new_pos >= 100 -> new_pos - 100
          true -> new_pos
        end

        # ¯\_(ツ)_/¯
        new_count = cond do
          # we hit 0
          new_pos == 0 -> count + 1
          # we were moving left and crossed over 0 but not started with 0
          direction == "L" and pos > 0 and new_pos < 0 -> count + 1
          # we were moving right and crossed over 0
          direction == "R" and new_pos >= 100 -> count + 1
          true -> count
        end

        new_count = new_count + rotations

        {actual_pos, new_count}
      end)
      |> IO.inspect()
  end
end

Day1.solution("input_test.txt")
Day1.solution("input.txt")
