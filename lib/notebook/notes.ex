defmodule Notebook.Notes do
  alias Notebook.FileSystem
  alias Notebook.Config

  @moduledoc """
  The Notes context.
  """

  @doc """
  Gets a single note.

  Raises if the Note does not exist.

  ## Examples

      iex> get_note!(:html, 'index.md')
      %Note{}

  """
  def get_note!(format, note) do
    Config.notes_path()
    |> Path.join(note)
    |> FileSystem.read()
    |> parse(format)
  end

  defp parse(note, :html) do
    Earmark.as_html!(note)
  end
end
