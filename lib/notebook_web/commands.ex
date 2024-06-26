defmodule NotebookWeb.Commands do
  use NotebookWeb, :verified_routes

  import Phoenix.LiveView

  alias Notebook.Config
  alias Notebook.FileSystem

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
    Config.notes_path()
    |> FileSystem.list()
    |> Enum.map(fn path ->
      {:nav_to, name: String.replace(path, "#{Config.notes_path()}/", ""), icon: "hero-document"}
    end)
  end

  def handle_command(:nav_to, context, socket) do
    push_navigate(socket, to: ~p"/notes/#{context[:name]}")
  end

  def handle_command(:nav_away, _context, socket) do
    push_navigate(socket, to: ~p"/#away")
  end
end
