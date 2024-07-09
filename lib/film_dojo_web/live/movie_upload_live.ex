defmodule FilmDojoWeb.MovieUploadLive do
  use FilmDojoWeb, :live_view
  alias FilmDojo.Context.MovieContext
  alias FilmDojo.Schema.Movie

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(form: to_form(Movie.changeset(%Movie{}, %{})))
     |> allow_upload(:poster_path, accept: ~w(.jpg .jpeg .png), max_entries: 1)
     |> allow_upload(:background_path, accept: ~w(.jpg .jpeg .png), max_entries: 1)}
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
    poster_path =
      consume_uploaded_entries(socket, :poster_path, &upload_static_file/2)
      |> List.first()

    background_path =
      consume_uploaded_entries(socket, :background_path, &upload_static_file/2)
      |> List.first()

    movie_params =
      movie_params
      |> Map.put("poster_path", poster_path)
      |> Map.put("background_path", background_path)

    case MovieContext.create_movie(movie_params) do
      {:ok, _movie} ->
        {:noreply,
         socket
         |> put_flash(:info, "Movie uploaded successfully!")
         |> push_navigate(to: ~p"/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Error uploading movie. Please check the form.")
         |> assign(form: to_form(changeset))}
    end
  end

  defp upload_static_file(%{path: path}, entry) do
    ext = Path.extname(entry.client_name)
    file_name = Path.basename(path) <> ext
    dest = Path.join(["priv", "static", "uploads", file_name])
    File.cp!(path, dest)
    "/uploads/#{file_name}"
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>


     <div>
      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:title]} type="text" label="Title" required />
        <.input field={@form[:description]} type="textarea" label="Description" required />
        <p> Poster </p>
        <.live_file_input upload={@uploads.poster_path} required />
        <p> Background </p>
        <.live_file_input upload={@uploads.background_path} required />
        <.button type="submit" phx-disable-with="Saving ...">Create Movie</.button>
      </.simple_form>
     </div>
    </div>
    """
  end
end
