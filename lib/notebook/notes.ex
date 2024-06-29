defmodule Notebook.Notes do
  alias Notebook.FileSystem
  alias Notebook.Config

  @moduledoc """
  The Notes context.
  """

  @doc """
  Gets a list of notes whitin notebook

  ## Examples

      iex> Notes.list_notes()
      [
        {"test.md", "/Users/rastasheep/.notebook/default/notes/test.md"},
        {"proj/another.md", "/Users/rastasheep/.notebook/default/notes/proj/another.md"
      ]
  """

  def list_notes() do
    Config.notes_path()
    |> FileSystem.list()
    |> Enum.map(fn p -> {Path.relative_to(p, Config.notes_path()), p} end)
  end

  @doc """
  Gets a single note.

  Raises if the Note does not exist.

  ## Examples

      iex> Notes.get_note!(:html, 'index.md')
      "<h1>Note-content</h1>"

      iex> Notes.get_note!('index.md')
      "# Note-content"
  """

  def get_note!(:html, note) do
    get_note!(note)
    |> Earmark.as_html!()
  end

  def get_note!(note) do
    Config.notes_path()
    |> Path.join(note)
    |> FileSystem.read()
  end
end
