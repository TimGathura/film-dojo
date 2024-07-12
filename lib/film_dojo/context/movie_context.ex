defmodule FilmDojo.Context.MovieContext do
  import Ecto.Query, warn: false

  alias FilmDojo.Repo           # the repo or Database
  alias FilmDojo.Schema.Movie  # the schema

  # Lists all movies in the Movies struct or schema
  def list_movies do
    Repo.all(Movie)
  end

  # Fetches a movie by its id and returns Error is no record was found
  def get_movie!(id), do: Repo.get!(Movie, id)

  def create_movie(attrs \\ %{}) do
    %Movie{}
    |> Movie.changeset(attrs)
    |> Repo.insert()
  end

  def update_movie(%Movie{} = movie, attrs) do
    # Only delete old files if new ones are uploaded
    if Map.has_key?(attrs, "poster_path"), do: delete_file(movie.poster_path)
    if Map.has_key?(attrs, "background_path"), do: delete_file(movie.background_path)
    if Map.has_key?(attrs, "trailer_path"), do: delete_file(movie.trailer_path)
    if Map.has_key?(attrs, "movie_path"), do: delete_file(movie.movie_path)

    movie
    |> Movie.changeset(attrs)
    |> Repo.update()
  end

  def change_movie(%Movie{} = movie, attrs \\ %{}) do
    Movie.changeset(movie, attrs)
  end

  def save_movie(attrs \\ %{}) do
    %Movie{}
    |> Movie.changeset(attrs)
    |> Repo.insert()
  end

  def delete_movie(%Movie{} = movie) do
    # Delete associated files
    delete_file(movie.poster_path)
    delete_file(movie.background_path)
    delete_file(movie.trailer_path)
    delete_file(movie.movie_path)

    # Delete the database record
    Repo.delete(movie)
  end

  defp delete_file(nil), do: :ok
  defp delete_file(path) do
    path
    |> String.trim_leading("/")
    |> File.rm()
  end

end
