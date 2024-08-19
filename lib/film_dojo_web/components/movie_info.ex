defmodule FilmDojoWeb.Components.MovieInfo do
  use FilmDojoWeb, :html

  embed_templates "comps/movie_info_content.html"

  attr :movie, :map, required: true
  attr :show_trailer, :boolean, required: true

  def movie_info(assigns) do
    ~H"""
    <.movie_info_content />
    """
  end
end
