defmodule FilmDojoWeb.MoviePlayerLive do
  use FilmDojoWeb, :hero_view

  alias FilmDojo.Context.MovieContext

  import FilmDojoWeb.Components.Nav

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    movie = MovieContext.get_movie!(id)
    {:ok, assign(socket, movie: movie)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="main" class=" h-screen art-station-bg w-100">
      <.nav_content />

      <div class="border border-white mt-10 img">
        <h1 class="text-3xl font-blacknorth text-white mb-5"> <%= @movie.title %> </h1>
        <div class="img-cont">
          <video controls class="img aspect-16-9">
            <source src={@movie.movie_path} type="video/mp4">
            Your browser does not support the video tag.
          </video>
        </div>

        <!--
        <div class="mt-5 text-white">
          <p class="text-xl"><%= @movie.description %></p>
          <p class="mt-3">Duration: <%= @movie.duration %></p>
          <p>Genre: <%= @movie.genre %></p>
          <p>Year: <%= @movie.year %></p>
          <p>Rating: <%= @movie.ratings %></p>
        </div>
        -->
      </div>
    </div>
    """
  end
end
