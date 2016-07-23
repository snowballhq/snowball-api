defmodule Snowball.Clip do
  use Snowball.Web, :model
  use Arc.Ecto.Schema

  schema "clips" do
    belongs_to :user, Snowball.User
    field :video, Snowball.ClipVideo.Type
    field :thumbnail_file_name, :string
    timestamps [inserted_at: :created_at]
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id])
    |> put_uuid # A UUID does not exist when a clip is created. In order to save the video path correctly, we generate one manually
    |> cast_attachments(params, [:video])
    |> validate_required([:video, :user_id])
  end

  defp put_uuid(changeset) do
    if get_field(changeset, :id) do
      changeset
    else
      put_change(changeset, :id, Ecto.UUID.generate())
    end
  end
end
