defmodule Snowball.ClipView do
  use Snowball.Web, :view

  def render("index.json", %{clips: clips}) do
    render_many(clips, Snowball.ClipView, "clip.json")
  end

  def render("show.json", %{clip: clip}) do
    render_one(clip, Snowball.ClipView, "clip.json")
  end

  def render("clip.json", %{clip: clip}) do
    %{
      id: clip.id,
      user: render(Snowball.UserView, "show.json", %{user: clip.user})
    }
  end
end
