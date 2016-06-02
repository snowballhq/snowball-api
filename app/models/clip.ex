defmodule Snowball.Clip do
  use Snowball.Model

  schema "clips" do
    belongs_to :user, Snowball.User
    field :video_file_name, :string
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
    |> cast(params, [:user_id])
    |> validate_required([:video_file_name, :video_content_type, :thumbnail_file_name, :thumbnail_content_type, :user_id])
  end

  # TODO: UNTESTED
  def json(clip) do
    %{
      id: clip.id
    }
  end

  # # TODO: Remove this. It's littered across the models.
  # # Untested
  # def set_user_following(clip_or_clips, value) do
  #   if is_list(clip_or_clips) do
  #     clip_or_clips |> Enum.map(fn(clip) ->
  #       set_user_following(clip, value)
  #     end)
  #   else
  #     clip = clip_or_clips
  #     Map.put(clip, :user, Map.put(clip.user, :following, value))
  #   end
  # end
end
