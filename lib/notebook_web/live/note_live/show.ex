defmodule NotebookWeb.NoteLive.Show do
  use NotebookWeb, :live_view

  alias Notebook.Notes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    case Notes.get_note(:html, id) do
      {:ok, note} ->
        {:noreply,
         socket
         |> assign(:page_title, id)
         |> assign(:note, note)}

      {:error, _} ->
        {:noreply, redirect(socket, to: ~p"/")}
    end
  end
end
