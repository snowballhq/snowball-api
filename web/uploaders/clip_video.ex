defmodule Snowball.ClipVideo do
  use Arc.Definition
  use Arc.Ecto.Definition

  @acl :public_read
  @versions [:original, :standard, :image_standard]

  def validate({file, _}) do
    ~w(.mp4) |> Enum.member?(Path.extname(file.file_name))
  end

  def filename(version, {file, scope}), do: Path.rootname(file.file_name)

  def storage_dir(:image_standard, {file, scope}), do: "clips/thumbnails/#{scope.id}/standard"

  def storage_dir(version, {file, scope}), do: "clips/videos/#{scope.id}/#{version}"

  def transform(:standard, _) do
    {:ffmpeg, fn(input, output) -> "-i #{input} -vf scale=640:-1 -r 30 -ar 44100 -ac 1 -acodec aac -f mp4 #{output}" end, :mp4}
  end

  def transform(:image_standard, _) do
    {:ffmpeg, fn(input, output) -> "-i #{input} -vf scale=640:-1 -vframes 1 -f image2 #{output}" end, :jpg}
  end
end
