defmodule FilmDojoWeb.MovieEditLive do
  use FilmDojoWeb, :live_view

  alias FilmDojo.Context.MovieContext
  alias FilmDojo.Schema.Movie

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    movie = MovieContext.get_movie!(id)
    changeset = Movie.changeset(movie, %{})
    form = to_form(changeset, as: "movie")
    {:ok,
    socket
    |> assign(movie: movie, form: form, show_delete_modal: false)
    |> allow_upload(:poster, accept: ~w(.jpg .jpeg .png), max_entries: 1, max_file_size: 10_000_000)
    |> allow_upload(:background, accept: ~w(.jpg .jpeg .png), max_entries: 1, max_file_size: 10_000_000)
    |> allow_upload(:trailer, accept: ~w(.mp4 .mov .avi), max_entries: 1, max_file_size: 100_000_000)
    |> allow_upload(:movie, accept: ~w(.mp4 .mov .avi), max_entries: 1, max_file_size: 100_000_000)}
  end

  @impl true
  def handle_event("validate", %{"movie" => movie_params}, socket) do
    changeset =
      socket.assigns.movie
      |> Movie.changeset(movie_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  @impl true
  def handle_event("save", %{"movie" => movie_params}, socket) do
    IO.puts("Saving movie with params: #{inspect(movie_params)}")

    updated_params = handle_file_uploads(socket, movie_params)
    IO.puts("Updated params after file uploads: #{inspect(updated_params)}")

    case MovieContext.update_movie(socket.assigns.movie, updated_params) do
      {:ok, movie} ->
        IO.puts("Movie updated successfully")
        {:noreply,
        socket
        |> put_flash(:info, "Movie updated successfully")
        |> assign(movie: movie)
        |> push_navigate(to: ~p"/edit/#{movie.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts("Failed to update movie: #{inspect(changeset.errors)}")
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("delete", _params, socket) do
    {:noreply, assign(socket, show_delete_modal: true)}
  end

  def handle_event("confirm_delete", _, socket) do
    case MovieContext.delete_movie(socket.assigns.movie) do
      {:ok, _} ->
        {:noreply,
          socket
          |> put_flash(:info, "Movie deleted successfully!")
          |> push_navigate(to: ~p"/")}

      {:error, _} ->
        {:noreply,
          socket
          |> put_flash(:error, "Failed to delete movie")
          |> assign(show_delete_modal: false)}
    end
  end

  def handle_event("cancel_delete", _params, socket) do
    {:noreply, assign(socket, show_delete_modal: false)}
  end


  defp handle_file_uploads(socket, params) do
    Enum.reduce([:poster, :background, :trailer, :movie], params, fn field, acc ->
      case uploaded_entries(socket, field) do
        {[entry | _], []} ->
          IO.puts("Processing upload for #{field}")
          consume_uploaded_entry(socket, entry, fn %{path: path} ->
            dest = Path.join("uploads", "#{field}s/#{Path.basename(path)}")
            File.cp!(path, dest)
            IO.puts("File copied to #{dest}")
            Map.put(acc, "#{field}_path", "/#{dest}")
          end)
        _ ->
          IO.puts("No new upload for #{field}")
          acc
      end
    end)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto mt-8 p-6 bg-white rounded-lg shadow-md">
      <h2 class="text-2xl font-bold mb-6">Edit Movie</h2>
      <.form for={@form} phx-change="validate" phx-submit="save" class="space-y-6">
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:ratings]} type="number" label="Ratings" step="0.1" min="0" max="10" />
        <.input field={@form[:year]} type="number" label="Year" min="1888" />
        <.input field={@form[:duration]} type="text" label="Duration" />
        <.input field={@form[:genre]} type="text" label="Genre" />

        <div class="space-y-4">
          <label class="block font-medium text-sm text-gray-700">Poster</label>
          <img src={@movie.poster_path} alt="Movie Poster" class="w-64 h-auto mb-2" />
          <.live_file_input upload={@uploads.poster} />
        </div>

        <div class="space-y-4">
          <label class="block font-medium text-sm text-gray-700">Background</label>
          <img src={@movie.background_path} alt="Movie Background" class="w-full h-auto mb-2" />
          <.live_file_input upload={@uploads.background} />
        </div>

        <div class="space-y-4">
          <label class="block font-medium text-sm text-gray-700">Trailer</label>
          <video controls class="w-full mb-2">
            <source src={@movie.trailer_path} type="video/mp4">
            Your browser does not support the video tag.
          </video>
          <.live_file_input upload={@uploads.trailer} />
        </div>

        <div class="space-y-4">
          <label class="block font-medium text-sm text-gray-700">Movie</label>
          <video controls class="w-full mb-2">
            <source src={@movie.movie_path} type="video/mp4">
            Your browser does not support the video tag.
          </video>
          <.live_file_input upload={@uploads.movie} />
        </div>

        <div class="flex justify-between">
          <.button type="submit" phx-disable-with="Saving..." class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
            Save Changes
          </.button>

          <.button phx-click="delete" class="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded">
            Delete Movie
          </.button>
        </div>
      </.form>

      <%= if @show_delete_modal do %>
        <div class="fixed z-10 inset-0 overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
          <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
            <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"></div>
            <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
            <div class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
              <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                <div class="sm:flex sm:items-start">
                  <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                    <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-title">
                      Delete Movie
                    </h3>
                    <div class="mt-2">
                      <p class="text-sm text-gray-500">
                        Are you sure you want to delete this movie? This action cannot be undone.
                      </p>
                    </div>
                  </div>
                </div>
              </div>
              <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
                <button type="button" phx-click="confirm_delete" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus-color:red-500 sm:ml-3 sm:w-auto sm:text-sm">
                  Delete
                </button>
                <button type="button" phx-click="cancel_delete" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
                  Cancel
                </button>
              </div>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end


end
