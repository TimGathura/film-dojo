defmodule Mix.Tasks.MoveUploads do
  use Mix.Task
  import Ecto.Query
  alias FilmDojo.Repo
  alias FilmDojo.Schema.Movie

  def run(_) do
    Mix.Task.run("app.start")

    IO.puts("Starting file move operation...")

    File.mkdir_p!("uploads/posters")
    File.mkdir_p!("uploads/backgrounds")

    IO.puts("Created directories: uploads/posters and uploads/backgrounds")

    Enum.each(["posters", "backgrounds"], fn folder ->
      IO.puts("Processing folder: #{folder}")
      files = Path.wildcard("priv/static/uploads/*")
      IO.puts("Found #{length(files)} files in priv/static/uploads")

      Enum.each(files, fn file ->
        filename = Path.basename(file)
        new_path = "uploads/#{folder}/#{filename}"
        IO.puts("Attempting to copy #{file} to #{new_path}")

        case File.cp(file, new_path) do
          :ok ->
            IO.puts("Successfully copied #{file} to #{new_path}")

            # Update database entries
            field = if folder == "posters", do: :poster_path, else: :background_path
            {updated_count, _} = Repo.update_all(
              from(m in Movie, where: like(field(m, ^field), ^"%#{filename}")),
              set: [{field, "/#{new_path}"}]
            )

            IO.puts("Updated #{updated_count} database entries for #{filename}")

          {:error, reason} ->
            IO.puts("Failed to copy #{file} to #{new_path}: #{reason}")
        end
      end)
    end)

    IO.puts("File move operation completed!")
  end
end
