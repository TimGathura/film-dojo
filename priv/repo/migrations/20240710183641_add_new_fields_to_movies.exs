defmodule FilmDojo.Repo.Migrations.AddNewFieldsToMovies do
  use Ecto.Migration

  def change do
    alter table(:movies) do
      modify :description, :text

      unless index(:movies, [:ratings]) do
        add :ratings, :float
      end

      unless index(:movies, [:year]) do
        add :year, :integer
      end

      unless index(:movies, [:duration]) do
        add :duration, :string
      end

      unless index(:movies, [:genre]) do
        add :genre, :string
      end

      unless index(:movies, [:trailer_path]) do
        add :trailer_path, :string
      end

      unless index(:movies, [:movie_path]) do
        add :movie_path, :string
      end
    end
  end
end
