defmodule NotebookWeb.JournalLive.Show do
  use NotebookWeb, :live_view

  alias Notebook.Journals

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    case Journals.parse_file_name_to_date(id) do
      {date, _} ->
        d = Calendar.strftime(date, "%B %d, %Y")

        case Journals.get_journal(:html, date) do
          {:ok, journal} ->
            {:noreply,
             socket
             |> assign(:page_title, d)
             |> assign(:journal, journal)}

          {:error, _} ->
            {:noreply, redirect(socket, to: ~p"/journals")}
        end

      {:error} ->
        {:noreply, redirect(socket, to: ~p"/journals")}
    end
  end
end
