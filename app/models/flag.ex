defmodule Snowball.Flag do
  use Snowball.Model

  schema "flags" do
    belongs_to :clip, Snowball.Clip
    timestamps [inserted_at: :created_at]
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:clip_id])
    |> validate_required([:clip_id])
  end

  # TODO: UNTESTED
  def json(flag) do
    %{
      id: flag.id
    }
  end
end
