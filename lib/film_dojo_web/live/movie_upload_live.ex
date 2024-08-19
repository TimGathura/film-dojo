defmodule FilmDojoWeb.MovieUploadLive do
  use FilmDojoWeb, :nav_layout
  alias FilmDojo.Context.MovieContext
  alias FilmDojo.Schema.Movie

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(changeset: Movie.changeset(%Movie{}, %{}))
     |> allow_upload(:poster_path, accept: ~w(.jpg .jpeg .png), max_entries: 1, max_file_size: 10_000_000)
     |> allow_upload(:background_path, accept: ~w(.jpg .jpeg .png), max_entries: 1, max_file_size: 10_000_000)
     |> allow_upload(:trailer_path, accept: ~w(.mp4 .mov .avi), max_entries: 1, max_file_size: 100_000_000)
     |> allow_upload(:movie_path, accept: ~w(.mp4 .mov .avi), max_entries: 1, max_file_size: 100_000_000)}
  end

  @impl true
  def handle_event("validate", %{"movie" => movie_params}, socket) do
    changeset =
      %Movie{}
      |> Movie.changeset(movie_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"movie" => movie_params}, socket) do
    upload_files = get_uploaded_entries(socket)

    movie_params = Map.merge(movie_params, upload_files)

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
         |> assign(changeset: changeset)}
    end
  end

  defp get_uploaded_entries(socket) do
    Enum.reduce([:poster_path, :background_path, :trailer_path, :movie_path], %{}, fn field, acc ->
      case uploaded_entries(socket, field) do
        [{entry, _}] ->
          path = Path.join("uploads", "#{field}/#{entry.uuid}-#{entry.client_name}")
          Map.put(acc, Atom.to_string(field), path)
        _ ->
          acc
      end
    end)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form :let={f} for={@changeset} phx-change="validate" phx-submit="save" multipart>
        <.input field={f[:title]} type="text" label="Title" required />
        <.input field={f[:description]} type="textarea" label="Description" required />
        <.input field={f[:ratings]} type="number" label="Ratings" step="0.1" min="0" max="10" required />
        <.input field={f[:year]} type="number" label="Year" min="1888" required />
        <.input field={f[:duration]} type="text" label="Duration" required />
        <.input field={f[:genre]} type="text" label="Genre" required />

        <div>
          <label>Poster</label>
          <.live_file_input upload={@uploads.poster_path} />
          <%= for entry <- @uploads.poster_path.entries do %>
            <p>File selected: <%= entry.client_name %></p>
          <% end %>
        </div>

        <div>
          <label>Background</label>
          <.live_file_input upload={@uploads.background_path} />
          <%= for entry <- @uploads.background_path.entries do %>
            <p>File selected: <%= entry.client_name %></p>
          <% end %>
        </div>

        <div>
          <label>Trailer</label>
          <.live_file_input upload={@uploads.trailer_path} />
          <%= for entry <- @uploads.trailer_path.entries do %>
            <p>File selected: <%= entry.client_name %></p>
          <% end %>
        </div>

        <div>
          <label>Movie</label>
          <.live_file_input upload={@uploads.movie_path} />
          <%= for entry <- @uploads.movie_path.entries do %>
            <p>File selected: <%= entry.client_name %></p>
          <% end %>
        </div>

        <.button type="submit" phx-disable-with="Saving ...">Create Movie</.button>
      </.form>
    </div>
    """
  end
end
