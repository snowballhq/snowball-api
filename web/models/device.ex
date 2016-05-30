defmodule Snowball.Device do
  use Snowball.Web, :model

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
end
