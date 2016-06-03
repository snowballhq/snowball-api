defmodule Snowball.Like do
  use Snowball.Web, :model

  schema "likes" do
    belongs_to :user, Snowball.User
    belongs_to :clip, Snowball.Clip
    timestamps [inserted_at: :created_at]
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :clip_id])
    |> validate_required([:user_id, :clip_id])
  end
end
