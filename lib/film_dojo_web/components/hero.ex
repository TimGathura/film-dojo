defmodule FilmDojoWeb.Components.Hero do
  use FilmDojoWeb, :html

  embed_templates "hero/hero_content.html"

  def hero(assigns) do
    ~H"""
    <.hero_content />
    """
  end


end
