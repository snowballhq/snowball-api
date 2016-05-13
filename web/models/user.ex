defmodule Snowball.User do
  use Snowball.Web, :model

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
