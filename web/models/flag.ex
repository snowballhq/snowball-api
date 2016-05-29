defmodule Snowball.Flag do
  use Snowball.Web, :model

  schema "flags" do
    belongs_to :clip, Snowball.Clip
    timestamps [inserted_at: :created_at]
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:clip_id])
    |> validate_required([:clip_id])
  end
end
