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
      {:nav_away, name: "Clap along", icon: "hero-face-smile"}
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

  def handle_command(:nav_away, _context, socket) do
    push_navigate(socket, to: ~p"/#away")
  end
end
