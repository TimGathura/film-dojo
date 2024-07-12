defmodule Mix.Tasks.VerifyPaths do
  use Mix.Task
  alias FilmDojo.Repo
  alias FilmDojo.Schema.Movie

  def run(_) do
    Mix.Task.run("app.start")

    Repo.all(Movie)
    |> Enum.each(fn movie ->
      verify_path(movie.id, movie.poster_path, "poster")
      verify_path(movie.id, movie.background_path, "background")
    end)
  end

  defp verify_path(id, path, type) do
    if path && !File.exists?(Path.join(".", path)) do
      IO.puts("Warning: #{type} file for movie ID #{id} not found at #{path}")
    end
  end
end
