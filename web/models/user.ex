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
    field :email, :string

    timestamps
  end

  @required_fields ~w(username email)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
