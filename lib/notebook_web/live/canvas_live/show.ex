defmodule NotebookWeb.CanvasLive.Show do
  alias Notebook.Canvases
  use NotebookWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    socket =
      socket
      |> assign(:page_title, id)
      |> assign(:theme, "dark")

    case Canvases.get_canvas(id) do
      {:ok, canvas} ->
        {:noreply,
         socket
         |> assign(:canvas, canvas)}

      {:error, _} ->
        {:noreply,
         socket
         |> assign(:canvas, "{}")}
    end
  end

  @impl true
  def handle_event("save", canvas, socket) do
    case Canvases.update_canvas(socket.assigns.page_title, canvas) do
      {:ok, _canvas} ->
        {:noreply, socket}

      {:error, err} ->
        {:noreply,
         socket
         |> put_flash(:error, err)}
    end
  end
end
