defmodule FilmDojo.Repo.Migrations.UpdateExistingMoviePaths do
  use Ecto.Migration
  import Ecto.Query

  def up do
    from(m in "movies",
      update: [set: [
        poster_path: fragment("CONCAT('/uploads/posters/', SUBSTRING(poster_path FROM '[^/]+$'))"),
        background_path: fragment("CONCAT('/uploads/backgrounds/', SUBSTRING(background_path FROM '[^/]+$'))")
      ]]
    )
    |> FilmDojo.Repo.update_all([])
  end

  def down do
    from(m in "movies",
      update: [set: [
        poster_path: fragment("CONCAT('/images/', SUBSTRING(poster_path FROM '[^/]+$'))"),
        background_path: fragment("CONCAT('/images/', SUBSTRING(background_path FROM '[^/]+$'))")
      ]]
    )
    |> FilmDojo.Repo.update_all([])
  end
end
