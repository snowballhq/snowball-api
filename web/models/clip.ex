defmodule Snowball.Clip do
  use Snowball.Web, :model
  use Arc.Ecto.Schema

  schema "clips" do
    belongs_to :user, Snowball.User
    field :video_file_name, Snowball.ClipVideo.Type
    field :video_content_type, :string
    field :thumbnail_file_name, :string
    field :thumbnail_content_type, :string
    field :video_file_size, :string
    field :thumbnail_file_size, :string
    field :video_updated_at, Ecto.DateTime
    field :thumbnail_updated_at, Ecto.DateTime
    timestamps [inserted_at: :created_at]
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id], [:video_content_type, :thumbnail_file_name, :thumbnail_content_type]) # TODO: Remove these three
    |> put_uuid # A UUID does not exist when a clip is created. In order to save the video path correctly, we generate one manually
    |> cast_attachments(params, [:video_file_name])
    |> validate_required([:video_file_name, :video_content_type, :thumbnail_file_name, :thumbnail_content_type, :user_id])
  end

  defp put_uuid(changeset) do
    if get_field(changeset, :id) do
      changeset
    else
      put_change(changeset, :id, Ecto.UUID.generate())
    end
  end
end
