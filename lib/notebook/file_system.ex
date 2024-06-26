defmodule Notebook.FileSystem do
  def read(path) do
    path
    |> ensure_extension(".md")
    |> File.read!()
  end

  def list(path) do
    path
    |> Path.join("**/*.*")
    |> Path.wildcard()
  end

  defp ensure_extension(file_name, extension) do
    case Path.extname(file_name) do
      "" -> file_name <> extension
      _ -> file_name
    end
  end
end
