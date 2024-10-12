defmodule Notebook.Canvases do
  alias Notebook.FileSystem
  alias Notebook.Config

  @moduledoc """
  The Canvases context.
  """

  @doc """
  Gets a list of canvases whitin notebook

  ## Examples

      iex> Canvases.list_canvases()
      [
        {"test.excalidraw", "/Users/rastasheep/.notebook/default/canvases/test.excalidraw"},
        {"proj/another.excalidraw", "/Users/rastasheep/.notebook/default/canvases/proj/another.excalidraw"
      ]
  """

  def list_notes() do
    Config.canvases_path()
    |> FileSystem.list()
    |> Enum.map(fn p -> {Path.relative_to(p, Config.canvases_path()), p} end)
  end

  @doc """
  Gets a single canvas.


  ## Examples

      iex> Canvases.get_canvas('index.excalidraw')
      {:ok, "# Note-content"}
  """

  def get_canvas(canvas) do
    Config.canvases_path()
    |> Path.join(canvas)
    |> FileSystem.read(".excalidraw")
  end

  def update_canvas(canvas, content) do
    case Jason.encode(content) do
      {:ok, content} ->
        {:ok,
         Config.canvases_path()
         |> Path.join(canvas)
         |> FileSystem.write(content, ".excalidraw")}

      {:error, error} ->
        {:error, error}
    end
  end
end
