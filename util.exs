defmodule Util do
  def read_lines(path) do
    {:ok, contents} = File.read(path)
    String.split(contents, "\n", trim: true)
  end

  def read_chars(path) do
    {:ok, contents} = File.read(path)
    String.graphemes(contents)
  end
end
