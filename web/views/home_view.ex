defmodule Snowball.HomeView do
  use Snowball.Web, :view

  def render("index.text", _assigns) do
    "⛄"
  end
end
