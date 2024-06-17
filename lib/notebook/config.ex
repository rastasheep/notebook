defmodule Notebook.Config do
  def notes_path() do
    [
      notebook_path(),
      notes_folder()
    ]
    |> Path.join()
    |> Path.expand()
  end

  defp notebook_path() do
    Application.fetch_env!(:notebook, :notebook_path)
  end

  defp notes_folder() do
    Application.fetch_env!(:notebook, :notes_folder)
  end
end
