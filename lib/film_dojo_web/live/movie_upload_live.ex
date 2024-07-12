defmodule FilmDojoWeb.MovieUploadLive do
  use FilmDojoWeb, :live_view

  alias FilmDojo.Context.MovieContext
  alias FilmDojo.Schema.Movie

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(form: to_form(Movie.changeset(%Movie{}, %{})))
     |> allow_upload(:poster_path, accept: ~w(.jpg .jpeg .png), max_entries: 1, max_file_size: 10_000_000)  # Max 10 MBs
     |> allow_upload(:background_path, accept: ~w(.jpg .jpeg .png), max_entries: 1, max_file_size: 10_000_000)  # Max 10 MBs
     |> allow_upload(:trailer_path, accept: ~w(.mp4 .mov .avi), max_entries: 1, max_file_size: 100_000_000)  # Max 100 MBs
     |> allow_upload(:movie_path, accept: ~w(.mp4 .mov .avi), max_entries: 1, max_file_size: 100_000_000),
     layout: {FilmDojoWeb.Layouts, :nav_layout}}  # Max 100 MBs
  end

  @impl true
  def handle_event("validate", %{"movie" => movie_params}, socket) do
    form =
      %Movie{}
      |> Movie.changeset(movie_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  @impl true
  def handle_event("save", %{"movie" => movie_params}, socket) do
      poster_path = upload_file(socket, :poster_path, "posters")
      background_path = upload_file(socket, :background_path, "backgrounds")
      trailer_path = upload_file(socket, :trailer_path, "trailers")
      movie_path = upload_file(socket, :movie_path, "movies")

      movie_params =
        movie_params
        |> Map.put("poster_path", poster_path)
        |> Map.put("background_path", background_path)
        |> Map.put("trailer_path", trailer_path)
        |> Map.put("movie_path", movie_path)

      case MovieContext.create_movie(movie_params) do
        {:ok, _movie} ->
          {:noreply,
          socket
          |> put_flash(:info, "Movie uploaded successfully!")
          |> push_navigate(to: ~p"/")}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply,
          socket
          |> put_flash(:error, "Error uploading movie: #{inspect(changeset.errors)}")
          |> assign(form: to_form(changeset))}
      end
  end

  defp upload_file(socket, field, folder) do
    consume_uploaded_entries(socket, field, fn %{path: path}, entry ->
      dest = Path.join(["uploads", folder, "#{entry.uuid}-#{entry.client_name}"])
      File.cp!(path, dest)
      {:ok, "/uploads/#{folder}/#{entry.uuid}-#{entry.client_name}"}
    end)
    |> List.first()
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:title]} type="text" label="Title" required />
        <.input field={@form[:description]} type="textarea" label="Description" required />
        <.input field={@form[:ratings]} type="number" label="Ratings" step="0.1" min="0" max="10" required />
        <.input field={@form[:year]} type="number" label="Year" min="1888" required />
        <.input field={@form[:duration]} type="text" label="Duration" required />
        <.input field={@form[:genre]} type="text" label="Genre" required />
        <p>Poster</p>
        <.live_file_input upload={@uploads.poster_path} required />
        <p>Background</p>
        <.live_file_input upload={@uploads.background_path} required />
        <p>Trailer</p>
        <.live_file_input upload={@uploads.trailer_path} required />
        <p>Movie</p>
        <.live_file_input upload={@uploads.movie_path} required />
        <.button type="submit" phx-disable-with="Saving ...">Create Movie</.button>
      </.simple_form>
    </div>
    """
  end
end
