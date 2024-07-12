defmodule FilmDojoWeb.HeroLive do
  use FilmDojoWeb, :live_view

  alias FilmDojo.Context.MovieContext
  import FilmDojoWeb.Components.Hero
  import FilmDojoWeb.Components.Nav

  @default_movie %{
    id: nil,
    title: "Welcome to Film Dojo",
    description: "Start by adding your first movie!",
    background_path: "/images/Gojo_bg.png",
    poster_path: "/images/default_poster.jpg"
  }



  @impl true
  def mount(_params, _session, socket) do
    movies = MovieContext.list_movies()
    current_movie = List.first(movies) || @default_movie
    {:ok, assign(socket, movies: movies, current_movie: current_movie, show_trailer: false), layout: {FilmDojoWeb.Layouts, :hero}}
    #{:ok, socket, layout: {FilmDojoWeb.Layouts, :hero}}
  end

  @impl true
  def handle_event("select_movie", %{"id" => id}, socket) do
    case MovieContext.get_movie!(id) do
      nil ->
        {:noreply, socket}
      movie ->
        {:noreply, socket
          |> assign(current_movie: movie)
          |> push_event("movie-selected", %{})}
        # {:noreply, assign(socket, current_movie: movie)}
    end
  end

  def handle_event("show_trailer", _params, socket) do
    {:noreply, assign(socket, show_trailer: true)}
  end

  def handle_event("close_trailer", _params, socket) do
    {:noreply, assign(socket, show_trailer: false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="main" class="h-screen overflow-y-hidden w-full" style={"background-image: url(#{@current_movie.background_path || "/images/Gojo_bg.png"}); background-size: cover; background-repeat: no-repeat;"}>
      <.nav_content />
      <.hero_content current_movie={@current_movie} movies={@movies} />

      <%= if @show_trailer do %>
        <div class="fixed z-50 inset-0 overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
          <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
            <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"></div>
            <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
            <div class="inline-block align-bottom bg-black rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
              <div class="bg-black px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                <div class="sm:flex sm:items-start">
                  <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left w-full">
                    <h3 class="text-lg leading-6 font-medium text-white" id="modal-title">
                      <%= @current_movie.title %> - Trailer
                    </h3>
                    <div class="mt-2">
                      <video controls class="w-full">
                        <source src={@current_movie.trailer_path} type="video/mp4">
                        Your browser does not support the video tag.
                      </video>
                    </div>
                  </div>
                </div>
              </div>
              <div class="bg-black px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
                <button type="button" phx-click="close_trailer" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
                  Close
                </button>
              </div>
            </div>
          </div>
        </div>
      <% end %>
    </div>

    """
  end

end
