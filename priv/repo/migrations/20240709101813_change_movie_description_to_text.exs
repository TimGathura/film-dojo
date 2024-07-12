defmodule FilmDojo.Repo.Migrations.ChangeMovieDescriptionToText do
  use Ecto.Migration
  import Ecto.Query

  def up do
    alter table(:movies) do
      modify :description, :text
    end
  end

  def down do
    # First, let's create a temporary column
    alter table(:movies) do
      add :description_temp, :string
    end

    # Now, let's copy the data, truncating if necessary
    flush()

    from(m in "movies",
      update: [set: [description_temp: fragment("substring(description from 1 for 255)")]]
    )
    |> repo().update_all([])

    # Now we can safely drop the old column and rename the new one
    alter table(:movies) do
      remove :description
    end

    rename table(:movies), :description_temp, to: :description
  end
end
