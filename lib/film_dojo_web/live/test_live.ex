defmodule FilmDojoWeb.TestLive do
  use FilmDojoWeb, :live_view

  def render(assigns) do
    ~H"""
    <h2> You have to make a choice here: </h2>

    <button type="button" phx-click="show_root_flash" class="text-black bg-green-700 border rounded-lg p-2">
      Root is Shown!
    </button>
    <button type="button" phx-click="show_custom_flash" class="text-black bg-red-700 border rounded-lg p-2">
      Custom layout is Shown!
    </button>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket, layout: {FilmDojoWeb.Layouts, :hero}}
  end

  def handle_event("show_root_flash", _params, socket) do
    {:noreply, put_flash(socket, :info, "ROOT: Looks like you got the root file boi!")}
  end

  def handle_event("show_custom_flash", _params, socket) do
    {:noreply, put_flash(socket, :info, "CUSTOM: Looks like you got a custom file boi!")}
  end

end
