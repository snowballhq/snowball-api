defmodule Snowball.Follow do
  use Snowball.Web, :model

  # TODO: Create a "super" model
  # See this link: https://hexdocs.pm/ecto/2.0.0-rc.5/Ecto.Schema.html
  # under the "Schema attributes" seciton
  @primary_key {:id, :binary_id, read_after_writes: true}
  @foreign_key_type :binary_id
  @timestamps_opts [inserted_at: :created_at]

  schema "follows" do
    belongs_to :follower, Snowball.User
    belongs_to :following, Snowball.User
    timestamps [inserted_at: :created_at]
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:follower_id, :following_id])
    # |> validate_required([:follower_id, :following_id]) # TODO: Bring this back. See https://github.com/elixir-lang/ecto/issues/1265
  end
end
