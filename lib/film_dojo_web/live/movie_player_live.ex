defmodule FilmDojoWeb.MoviePlayerLive do
  use FilmDojoWeb, :live_view

  alias FilmDojo.Context.MovieContext

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    movie = MovieContext.get_movie!(id)
    {:ok, assign(socket, movie: movie), layout: {FilmDojoWeb.Layouts, :hero}}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container mx-auto mt-10">
      <h1 class="text-3xl font-bold mb-5"><%= @movie.title %></h1>
      <div class="aspect-w-16 aspect-h-9">
        <video controls class="w-full">
          <source src={@movie.movie_path} type="video/mp4">
          Your browser does not support the video tag.
        </video>
      </div>
      <div class="mt-5">
        <p class="text-xl"><%= @movie.description %></p>
        <p class="mt-3">Duration: <%= @movie.duration %></p>
        <p>Genre: <%= @movie.genre %></p>
        <p>Year: <%= @movie.year %></p>
        <p>Rating: <%= @movie.ratings %></p>
      </div>
    </div>
    """
  end
end
