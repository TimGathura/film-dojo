defmodule FilmDojo.Schema.Movie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movies" do
    field :background_path, :string
    field :description, :string
    field :poster_path, :string
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:title, :poster_path, :background_path, :description])
    |> validate_required([:title, :poster_path, :background_path, :description])
  end
end
