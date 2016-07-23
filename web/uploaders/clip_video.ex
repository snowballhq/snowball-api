defmodule Snowball.ClipVideo do
  use Arc.Definition
  use Arc.Ecto.Definition

  @acl :public_read
  @versions [:original, :small, :thumbnail]

  def validate({file, _}) do
    ~w(.mp4) |> Enum.member?(Path.extname(file.file_name))
  end

  def filename(version, {file, scope}), do: Path.rootname(file.file_name)

  def storage_dir(:thumbnail, {file, scope}), do: "clips/thumbnails/#{scope.id}/original"

  def storage_dir(version, {file, scope}), do: "clips/videos/#{scope.id}/#{version}"

  def transform(:small, _) do
    {:ffmpeg, fn(input, output) -> "-i #{input} -vf scale=100:-1 -f mp4 #{output}" end, :mp4}
  end

  def transform(:thumbnail, _) do
    {:ffmpeg, fn(input, output) -> "-i #{input} -ss 0 -vframes 1 -f image2 #{output}" end, :jpg}
  end
end
