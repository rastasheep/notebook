defmodule Notebook.FileSystem do
  def read(path) do
    path
    |> ensure_extension(".md")
    |> File.read()
  end

  def list(path, glob \\ "**/*.*") do
    path
    |> Path.join(glob)
    |> Path.wildcard()
  end

  defp ensure_extension(file_name, extension) do
    case Path.extname(file_name) do
      "" -> file_name <> extension
      _ -> file_name
    end
  end
end
