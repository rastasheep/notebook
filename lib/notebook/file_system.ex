defmodule Notebook.FileSystem do
  def read(path, default_extension) do
    path
    |> ensure_extension(default_extension)
    |> File.read()
  end

  def write(path, content, default_extension) do
    path
    |> ensure_extension(default_extension)
    |> File.write(content)
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
