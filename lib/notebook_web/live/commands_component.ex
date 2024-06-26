defmodule NotebookWeb.CommandsComponent do
  use NotebookWeb, :live_component

  @doc """
  Renders a command palette modal
  """
  attr :id, :string, required: true

  @impl true
  def render(assigns) do
    ~H"""
    <div id={@id} phx-window-keydown="input_key" phx-target={@myself} phx-key="k">
      <.modal :if={@show} id={"#{@id}-modal"} show on_cancel={JS.push("close", target: @myself)}>
        <.form
          :let={f}
          id={"#{@id}-content"}
          for={%{}}
          as={:command}
          phx-change="change"
          phx-submit="submit"
          phx-target={@myself}
        >
          <input
            id={f[:input].id}
            name={f[:input].name}
            value={f[:input].value}
            phx-keydown="input_key"
            phx-target={@myself}
            class="w-full rounded-md bg-white dark:bg-zinc-800 dark:text-zinc-300 px-4 py-2.5 placeholder-zinc-500 text-zinc-900 focus:outline-none"
            autocomplete="off"
            placeholder="Search..."
            role="combobox"
            aria-expanded="false"
            aria-controls="options"
          />
        </.form>

        <ul
          class="-mb-2 max-h-72 scroll-py-2 overflow-y-auto py-2 dark:text-zinc-300"
          id="options"
          role="listbox"
        >
          <li
            :for={{{_, command}, index} <- Enum.with_index(@commands)}
            class={[
              if(@selected_index == index, do: "bg-zinc-300 dark:text-zinc-900"),
              "cursor-pointer select-none rounded-md flex items-center px-4 py-2 hover:bg-sky-200 hover:text-zinc-900 dark:text-zinc-300"
            ]}
            phx-click="activate"
            phx-value-index={index}
            phx-target={@myself}
            role="option"
            tabindex="-1"
          >
            <.icon :if={command[:icon]} name={command[:icon]} class="h-3 w-3 mr-2 text-zinc-500" />

            <%= command[:name] %>
          </li>
        </ul>

        <div :if={@commands == []} class="py-14 px-4 text-center sm:px-14">
          <.icon name="hero-magnifying-glass-mini" class="mx-auto h-6 w-6 text-zinc-500" />
          <p class="mt-4">No commands found that match your search</p>
        </div>
      </.modal>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign(:show, false)
      |> get_commands()

    {:ok, socket}
  end

  @impl true
  def handle_event("input_key", params, socket) do
    commands = socket.assigns.commands
    selected_index = socket.assigns.selected_index

    case params do
      %{"key" => "Escape"} ->
        toggle_visibility(socket)

      %{"key" => "ArrowDown"} ->
        selected_index = min(selected_index + 1, length(commands) - 1)
        {:noreply, assign(socket, :selected_index, selected_index)}

      %{"key" => "ArrowUp"} ->
        selected_index = max(selected_index - 1, 0)
        {:noreply, assign(socket, :selected_index, selected_index)}

      %{"key" => "k", "metaKey" => true, "repeat" => false} ->
        toggle_visibility(socket)

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event("activate", %{"index" => index}, socket) do
    socket = assign(socket, :selected_index, String.to_integer(index))

    handle_event("submit", {}, socket)
  end

  def handle_event("change", %{"command" => %{"input" => input}}, socket) do
    {:noreply, get_commands(socket, input)}
  end

  def handle_event("submit", _command, socket) do
    commands = socket.assigns.commands
    selected_index = socket.assigns.selected_index

    case Enum.at(commands, selected_index) do
      nil ->
        toggle_visibility(socket)

      {id, opts} ->
        socket = NotebookWeb.Commands.handle_command(id, opts, socket)

        toggle_visibility(socket)
    end
  end

  def handle_event("open", _params, socket) do
    {:noreply, assign(socket, :show, true)}
  end

  def handle_event("close", _params, socket) do
    {:noreply, assign(socket, :show, false)}
  end

  def handle_event("toggle", _params, socket) do
    toggle_visibility(socket)
  end

  defp toggle_visibility(socket) do
    {:noreply, socket |> assign(show: !socket.assigns.show) |> get_commands()}
  end

  defp get_commands(socket, input \\ "") do
    commands =
      NotebookWeb.Commands.score(input)
      |> Enum.take(20)

    socket
    |> assign(:commands, commands)
    |> assign(:selected_index, 0)
  end
end
