defmodule Snowball.Clip do
  use Snowball.Web, :model

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
    |> validate_required([:video_file_name, :video_content_type, :thumbnail_file_name, :thumbnail_content_type])
    # |> validate_required([:user_id]) # TODO: Bring this back. See https://github.com/elixir-lang/ecto/issues/1265
  end
end
