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
      {:ok, "<h1>Note-content</h1>"}

      iex> Journals.get_journal!('2024_02_06.md')
      {:ok, "# Note-content"}
  """

  def get_journal(:html, date) do
    case get_journal(date) do
      {:ok, content} -> {:ok, Earmark.as_html!(content)}
      {:error, error} -> {:error, error}
    end
  end

  def get_journal(date) do
    Config.journals_path()
    |> FileSystem.list(Calendar.strftime(date, "{%Y_%m_%d,%Y_%m_%d}.md"))
    |> case do
      [file] -> FileSystem.read(file)
      [] -> {:error, :enoent}
    end
  end

  def get_relative_path(path) do
    Path.relative_to(path, Config.journals_path())
  end

  def parse_file_name_to_date(file_path) do
    file_name =
      file_path
      |> Path.basename(Path.extname(file_path))
      |> String.replace("_", "-")

    case Date.from_iso8601(file_name) do
      {:ok, date} -> {date, file_path}
      {:error, _} -> {:error}
    end
  end

  defp valid_date?({:error}), do: false
  defp valid_date?(_), do: true
end
