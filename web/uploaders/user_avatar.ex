defmodule Snowball.UserAvatar do
  use Arc.Definition
  use Arc.Ecto.Definition

  @acl :public_read
  @versions [:original]

  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  def filename(version, {_file, _scope}), do: version

  def storage_dir(_version, {_file, scope}), do: "users/avatars/#{scope.id}"
end
