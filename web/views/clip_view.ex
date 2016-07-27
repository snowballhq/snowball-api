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
    # TODO: This type of formatting shouldn't have to happen to remove microseconds. Fix?
    created_at = Ecto.DateTime.to_iso8601(clip.created_at) |> String.split(".") |> List.first
    %{
      id: clip.id,
      image: %{
        standard_resolution: %{
          url: generate_image_url(clip, :image_standard)
        }
      },
      video: %{
        standard_resolution: %{
          url: generate_video_url(clip, :standard)
        }
      },
      user: render_one(clip.user, Snowball.UserView, "user.json", assigns),
      liked: Snowball.User.likes?(assigns.current_user, clip),
      created_at: created_at <> "Z"
    }
  end

  # This is so we can holdover old legacy images until moved in S3
  # TODO: Once the S3 migration is completed, remove this
  defp generate_image_url(clip, version) do
    if clip.thumbnail_file_name do
      "https://snowball-production.s3.amazonaws.com/clips/thumbnails/#{clip.id}/original/" <> clip.thumbnail_file_name
    else
      Snowball.ClipVideo.url({clip.video, clip}, version)
    end
  end

  # This is so we can holdover old legacy videos until moved in S3
  # TODO: Once the S3 migration is completed, remove this
  defp generate_video_url(clip, version) do
    if clip.thumbnail_file_name do
      "https://snowball-production.s3.amazonaws.com/clips/videos/#{clip.id}/original/" <> clip.video.file_name
    else
      Snowball.ClipVideo.url({clip.video, clip}, version)
    end
  end
end
