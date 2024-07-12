defmodule FilmDojo.Schema.Movie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movies" do
    field :title, :string
    field :description, :string
    field :poster_path, :string
    field :background_path, :string
    field :ratings, :float
    field :year, :integer
    field :duration, :string
    field :genre, :string
    field :trailer_path, :string
    field :movie_path, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:title, :description, :poster_path, :background_path, :ratings, :year, :duration, :genre, :trailer_path, :movie_path])
    |> validate_required([:title, :description, :poster_path, :background_path, :ratings, :year, :duration, :genre])
    |> validate_number(:ratings, greater_than_or_equal_to: 0, less_than_or_equal_to: 10)
    |> validate_number(:year, greater_than_or_equal_to: 1888) # First movie ever made
    |> validate_length(:description, max: 500)
  end
end
