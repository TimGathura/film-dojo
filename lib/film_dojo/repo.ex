defmodule FilmDojo.Repo do
  use Ecto.Repo,
    otp_app: :film_dojo,
    adapter: Ecto.Adapters.Postgres
end
