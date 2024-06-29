defmodule Notebook.Journals do
  alias Notebook.FileSystem
  alias Notebook.Config

  @moduledoc """
  The Journals context.
  """

  @doc """
  Gets a list of journals whitin notebook, sorted by date in descending order

  ## Examples

      iex> Journals.list_journals()
      [
        {~D[2024-02-06], "/Users/rastasheep/.notebook/default/journals/2024_02_06.md"},
        {~D[2024-02-04], "/Users/rastasheep/.notebook/default/journals/2024_02_04.md"}
      ]
  """

  def list_journals() do
    Config.journals_path()
    |> FileSystem.list()
    |> Enum.map(&parse_file_name_to_date/1)
    |> Enum.filter(&valid_date?/1)
    |> Enum.sort_by(&elem(&1, 0), {:desc, Date})
  end

  @doc """
  Gets a single journal.

  Raises if the Journal does not exist.

  ## Examples

      iex> Journals.get_journal!(:html, '2024_02_06.md')
      "<h1>Note-content</h1>"

      iex> Journals.get_journal!('2024_02_06.md')
      "# Note-content"
  """

  def get_journal(:html, journal) do
    get_journal(journal)
    |> Earmark.as_html!()
  end

  def get_journal(journal) do
    Config.journals_path()
    |> Path.join(journal)
    |> FileSystem.read()
  end

  def get_relative_path(path) do
    Path.relative_to(path, Config.journals_path())
  end

  defp parse_file_name_to_date(file_path) do
    file_name = Path.basename(file_path, Path.extname(file_path))
    file_name = String.replace(file_name, "_", "-")

    case Date.from_iso8601(file_name) do
      {:ok, date} -> {date, file_path}
      {:error, :invalid_format} -> {:error}
    end
  end

  defp valid_date?({:error}), do: false
  defp valid_date?(_), do: true
end
