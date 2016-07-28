defmodule Snowball.ClipVideo do
  use Arc.Definition
  use Arc.Ecto.Definition

  @acl :public_read
  @versions [:original, :standard, :image_standard]

  def validate({file, _}) do
    ~w(.mp4) |> Enum.member?(Path.extname(file.file_name))
  end

  def filename(version, {_file, _scope}), do: version

  def storage_dir(_version, {_file, scope}), do: "clips/videos/#{scope.id}"

  def transform(:standard, _) do
    {:ffmpeg, fn(input, output) -> "-i #{input} -t 3 -vf scale=640:-1 -r 30 -ar 44100 -ac 1 -acodec aac -f mp4 #{output}" end, :mp4}
  end

  def transform(:image_standard, _) do
    {:ffmpeg, fn(input, output) -> "-i #{input} -vf scale=640:-1 -vframes 1 -f image2 #{output}" end, :jpg}
  end
end
