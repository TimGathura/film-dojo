defmodule FilmDojoWeb.Components.Nav do
  use FilmDojoWeb, :html

  embed_templates "hero/nav_content.html"

  def nav(assigns) do
    ~H"""
    <.nav_content />
    """
  end
end
