defmodule FilmDojo.Repo.Migrations.RenameTrailerToTrailerPath do
  use Ecto.Migration

  def change do
    rename table(:movies), :trailer, to: :trailer_path
  end
end
