defmodule Snowball.UserAvatar do
  use Arc.Definition
  use Arc.Ecto.Definition

  @acl :public_read
  @versions [:original]

  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  def filename(version, {file, scope}), do: Path.rootname(file.file_name)

  def storage_dir(version, {file, scope}), do: "users/avatars/#{scope.id}/#{version}"
end
