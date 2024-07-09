defmodule FilmDojo.Repo.Migrations.CreateMovies do
  use Ecto.Migration

  def change do
    create table(:movies) do
      add :title, :string
      add :poster_path, :string
      add :background_path, :string
      add :description, :string

      timestamps(type: :utc_datetime)
    end
  end
end
