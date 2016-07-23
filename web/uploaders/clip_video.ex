defmodule Snowball.ClipVideo do
  use Arc.Definition
  use Arc.Ecto.Definition

  @acl :public_read
  @versions [:original, :small]

  def validate({file, _}) do
    ~w(.mp4) |> Enum.member?(Path.extname(file.file_name))
  end

  def filename(version, {file, scope}), do: Path.rootname(file.file_name)

  def storage_dir(version, {file, scope}), do: "clips/videos/#{scope.id}/#{version}"

  def transform(:small, _) do
    {:ffmpeg, fn(input, output) -> "-i #{input} -vf scale=100:-1 -f mp4 #{output}" end, :mp4}
  end
end
