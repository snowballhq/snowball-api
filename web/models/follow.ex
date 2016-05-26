defmodule Snowball.Follow do
  use Snowball.Web, :model

  schema "follows" do
    belongs_to :follower, Snowball.User
    belongs_to :following, Snowball.User
    timestamps [inserted_at: :created_at]
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:follower_id, :following_id])
    |> validate_required([:follower_id, :following_id])
  end
end
