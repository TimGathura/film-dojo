defmodule FilmDojoWeb.HeroLive do
  use FilmDojoWeb, :live_view

  alias FilmDojo.Context.MovieContext

  @default_movie %{
    id: nil,
    title: "Welcome to Film Dojo",
    description: "Start by adding your first movie!",
    background_path: "/images/Gojo_bg.png",
    poster_path: "/images/default_poster.jpg"
  }



  @impl true
  def mount(_params, _session, socket) do
    movies = MovieContext.list_movies()
    current_movie = List.first(movies) || @default_movie
    {:ok, assign(socket, movies: movies, current_movie: current_movie), layout: {FilmDojoWeb.Layouts, :hero}}
    #{:ok, socket, layout: {FilmDojoWeb.Layouts, :hero}}
  end

  @impl true
  def handle_event("select_movie", %{"id" => id}, socket) do
    case MovieContext.get_movie!(id) do
      nil ->
        {:noreply, socket}
      movie ->
        {:noreply, assign(socket, current_movie: movie)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="main" class="overflow-y-auto w-full" style={"background-image: url(#{@current_movie.background_path}); background-size: cover; background-repeat: no-repeat;"} >
      <div id="main" class="overflow-hidden w-full h-screen" phx-update="replace">
        <.nav_comp />
        <.hero_comp current_movie={@current_movie} movies={@movies}/>

      </div>
    </div>
    """
  end

  def nav_comp(assigns) do
    ~H"""
    <div id="main_nav" class="flex items-center justify-between text-white h-nav">

      <div id="logo" class="font-zenzaiItachi text-5xl text-red-500 ml-16">
        <p> Film Dojo </p>
      </div>


      <div id="home" class="flex items-center justify-between mr-16">
        <ul class="flex items-center justify-between gap-12 text-nav">
          <li> Home </li>
          <li> Genre </li>
          <li> Country </li>
          <li> TV Shows </li>
          <li> Search </li>
          <li> Logout </li>
        </ul>
      </div>
    </div>
    """
  end

  def hero_comp(assigns) do
    ~H"""

    <div id="main_hero" class=" text-white h-full">

      <div id="content" class="flex-col justify-between pl-20 pt-24 w-cust h-cont">

        <div id="title" class="text-7xl font-blacknorth pt-2 w-title">
          <p> <%= @current_movie.title %> </p>
        </div>

        <ul id="genre" class="flex list-disc pl-4 gap-8 pt-2 text-gray-400">
          <li> Sci-Fi </li>
          <li> Action </li>
          <li> Adventure </li>
        </ul>

        <div id="ratings" class="flex items-center gap-2 pt-2">
         <img src={~p"/images/rotten-tomatoes.png"} width="30" />
         <p> 8.0 </p>
         <div class="h-4 border border-gray-500"> </div>
         <p class="text-gray-400"> 2024 </p>
         <div class="h-4 border border-gray-500"> </div>
         <p class="text-gray-400"> 2h 25m </p>
        </div>

        <div id="desc" class="pt-2">
          <p> <%= @current_movie.description %> </p>
        </div>

        <div id="buttons" class="pt-8 flex items-center gap-4 border-white">
          <button type="button" phx-click="show-trailer" class="border border-white rounded-lg py-2 px-4"> Watch trailer </button>
          <button type="button" phx-click="show-movie" class="flex items-center gap-2 rounded-lg bg-red-500 py-2 px-4 text-black">
            <img src={~p"/images/play.png"} width="24"/>
            Watch now
          </button>
        </div>

        <!-- <div id="pagenation" class="flex items-center gap-4 pt-12">
          <button type="button" class="border border-white rounded-lg p-4">
            <img src={~p"/images/left_arrow.png"} width="15" />
          </button>
          <button type="button" class="border border-white rounded-lg p-4">
            <img src={~p"/images/right_arrow.png"} width="15" />
          </button>
        </div> -->

      </div>


      <div id="card-cont" class="flex items-center gap-4 mt-24 h-card">
        <%= if  Enum.empty?(@movies) do %>
          <p class="text-white"> Looks like you dont got not movies. Add your first to get started! </p>
        <% else %>
          <%= for movie <- @movies do %>
            <div id="card" class="flex items-center max-h-img" phx-click="select_movie" phx-value-id={movie.id}>
              <img src={movie.poster_path} class={["rounded-lg", @current_movie.id == movie.id && "h-active" || "h-inactive"]} />
            </div>
          <% end %>
        <% end %>


          <!--
          <div id="card" class="flex items-center">
            <img src={~p"/images/kingdomapes_poster.png"} class="rounded-lg h-active" />
          </div>
          <div id="card" class="flex items-center">
            <img src={~p"/images/furiosa_poster.png"} class="rounded-lg h-inactive" />
          </div>
          <div id="card" class="flex items-center">
            <img src={~p"/images/oppenheimer_poster.png"} class="rounded-lg h-inactive" />
          </div>
          <div id="card" class="flex items-center">
            <img src={~p"/images/endgame_poster.png"} class="rounded-lg h-inactive" />
          </div>
          <div id="card" class="flex items-center">
            <img src={~p"/images/talk_to_me_poster.png"} class="rounded-lg h-inactive" />
          </div>
          <div id="card" class="flex items-center">
            <img src={~p"/images/first_omen_poster.png"} class="rounded-lg h-inactive" />
          </div>
          <div id="card" class="flex items-center">
            <img src={~p"/images/damsel_poster.png"} class="rounded-lg h-inactive" />
          </div>
          <div id="card" class="flex items-center">
            <img src={~p"/images/road_house_poster.png"} class="rounded-lg h-inactive" />
          </div>
          -->
      </div>



    </div>
    """
  end
end
