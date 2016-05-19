defmodule Snowball.User do
  use Snowball.Web, :model

  # TODO: Create a "super" model
  # See this link: https://hexdocs.pm/ecto/2.0.0-rc.5/Ecto.Schema.html
  # under the "Schema attributes" seciton
  @primary_key {:id, :binary_id, read_after_writes: true}
  @foreign_key_type :binary_id
  @timestamps_opts [inserted_at: :created_at]

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :password_digest, :string
    field :name, :string
    field :email, :string
    field :phone_number, :string
    field :auth_token, :string
    field :reset_password_token, :string
    field :reset_password_sent_at, Ecto.DateTime
    field :avatar_file_name, :string
    field :avatar_content_type, :string
    field :avatar_file_size, :string
    field :avatar_updated_at, Ecto.DateTime

    timestamps [inserted_at: :created_at]
  end

  @required_fields ~w(username email password)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
