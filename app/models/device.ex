defmodule Snowball.Device do
  use Snowball.Model

  schema "devices" do
    belongs_to :user, Snowball.User
    field :arn, :string
    timestamps [inserted_at: :created_at]
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :arn])
    |> validate_required([:user_id, :arn])
  end

  # TODO: UNTESTED
  def json(device) do
    %{
      id: device.id
    }
  end
end
