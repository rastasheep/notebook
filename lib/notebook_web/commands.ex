defmodule NotebookWeb.Commands do
  use NotebookWeb, :verified_routes

  import Phoenix.LiveView

  alias Notebook.Notes

  def score(string) do
    list_commands()
    |> Seqfuzz.matches(
      string,
      fn {_, c} -> c[:name] end,
      metadata: false,
      filter: true,
      sort: true
    )
  end

  defp list_commands() do
    open_note_commands() ++
      editor_commands()
  end

  defp editor_commands() do
    [
      {:nav_journal, name: "Journals", icon: "hero-book-open"},
      {:nav_journal_next, name: "Journals › Next", icon: "hero-book-open"}
    ]
  end

  defp open_note_commands() do
    Notes.list_notes()
    |> Enum.map(fn {name, _path} ->
      {:nav_to, name: name, icon: "hero-document"}
    end)
  end

  def handle_command(:nav_to, context, socket) do
    push_navigate(socket, to: ~p"/notes/#{context[:name]}")
  end

  def handle_command(:nav_journal, _context, socket) do
    push_navigate(socket, to: ~p"/journals")
  end

  def handle_command(:nav_journal_next, _context, socket) do
    push_navigate(socket, to: ~p"/journals/#{Date.utc_today() |> Date.add(1)}")
  end
end
