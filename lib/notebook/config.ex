defmodule Notebook.Config do
  def notes_path() do
    [notebook_path(), notes_folder()] |> expand_path()
  end

  defp expand_path(path) do
    path
    |> Path.join()
    |> Path.expand()
  end

  def notebook_path() do
    Application.fetch_env!(:notebook, :notebook_path)
  end

  defp notes_folder() do
    Application.fetch_env!(:notebook, :notes_folder)
  end
end
