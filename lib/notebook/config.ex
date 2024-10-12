defmodule Notebook.Config do
  def notes_path() do
    [fetch!(:notebook_path), fetch!(:notes_dir)] |> expand_path()
  end

  def journals_path() do
    [fetch!(:notebook_path), fetch!(:journals_dir)] |> expand_path()
  end

  def canvases_path() do
    [fetch!(:notebook_path), fetch!(:canvases_dir)] |> expand_path()
  end

  defp expand_path(path) do
    path
    |> Path.join()
    |> Path.expand()
  end

  defp fetch!(key) do
    Application.fetch_env!(:notebook, key)
  end
end
