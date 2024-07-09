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

end
