defmodule Snowball.Like do
  use Snowball.Model

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

  # TODO: UNTESTED
  def json(like) do
    %{
      id: like.id
    }
  end
end
