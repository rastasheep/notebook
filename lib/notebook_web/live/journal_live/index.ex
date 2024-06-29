defmodule NotebookWeb.JournalLive.Index do
  use NotebookWeb, :live_view

  alias Notebook.Journals

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Journals")
     |> assign(:infinite, true)
     |> assign(page: 1, per_page: 5)
     |> stream_configure(:journals, dom_id: fn {name, _, _} -> name end)
     |> assign(:journal_index, Journals.list_journals())
     |> paginate(1)}
  end

  @impl true
  def handle_event("next-page", _, socket) do
    {:noreply, paginate(socket, socket.assigns.page + 1)}
  end

  def handle_event("prev-page", %{"_overran" => true}, socket) do
    {:noreply, paginate(socket, 1)}
  end

  def handle_event("prev-page", _, socket) do
    if socket.assigns.page > 1 do
      {:noreply, paginate(socket, socket.assigns.page - 1)}
    else
      {:noreply, socket}
    end
  end

  defp paginate(socket, new_page) when new_page >= 1 do
    %{per_page: per_page, page: cur_page, journal_index: journal_index} = socket.assigns

    journals =
      Enum.slice(journal_index, (new_page - 1) * per_page, per_page)
      |> Enum.map(fn {name, path} ->
        content = Journals.get_journal(:html, Journals.get_relative_path(path))
        {name, path, content}
      end)

    {journals, at, limit} =
      if new_page >= cur_page do
        {journals, -1, per_page * 3 * -1}
      else
        {Enum.reverse(journals), 0, per_page * 3}
      end

    case journals do
      [] ->
        assign(socket, end_of_timeline?: at == -1)

      [_ | _] = journals ->
        socket
        |> assign(end_of_timeline?: false)
        |> assign(:page, new_page)
        |> stream(:journals, journals, at: at, limit: limit)
    end
  end
end
