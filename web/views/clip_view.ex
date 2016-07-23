defmodule Snowball.ClipView do
  use Snowball.Web, :view

  def render("index.json", assigns) do
    render_many(assigns.clips, Snowball.ClipView, "clip.json", assigns)
  end

  def render("show.json", assigns) do
    render_one(assigns.clip, Snowball.ClipView, "clip.json", assigns)
  end

  def render("clip.json", assigns) do
    clip = assigns.clip
    %{
      id: clip.id,
      image: %{
        low_resolution: %{
          url: Snowball.ClipVideo.url({clip.video_file_name, clip}, :image_low)
        },
        standard_resolution: %{
          url: Snowball.ClipVideo.url({clip.video_file_name, clip}, :image_standard)
        }
      },
      video: %{
        low_resolution: %{
          url: Snowball.ClipVideo.url({clip.video_file_name, clip}, :low)
        },
        standard_resolution: %{
          url: Snowball.ClipVideo.url({clip.video_file_name, clip}, :standard)
        }
      },
      user: render_one(clip.user, Snowball.UserView, "user.json", assigns),
      created_at: clip.created_at
    }
  end
end
