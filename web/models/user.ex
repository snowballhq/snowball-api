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

  # TODO: Add validations
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(username email), ~w(password))
    |> hash_password
  end

  # TODO: Add validations
  def registration_changeset(model, params \\ :empty) do
    model
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> generate_auth_token
  end

  # TODO: Ensure this is compatible with current production
  defp hash_password(changeset) do
    if password = get_change(changeset, :password) do
      changeset
      |> put_change(:password_digest, Comeonin.Bcrypt.hashpwsalt(password))
    else
      changeset
    end
  end

  # TODO: Ensure auth token is unique
  defp generate_auth_token(changeset) do
    if !get_field(changeset, :auth_token) do
      length = 20
      rlength = (length * 3) / 4

      auth_token = SecureRandom.urlsafe_base64(round(rlength))
      |> String.replace("lIO0", "sxyz")
      |> String.replace("l", "s")
      |> String.replace("I", "x")
      |> String.replace("O", "y")
      |> String.replace("0", "z")

      changeset
      |> put_change(:auth_token, auth_token)
    else
      changeset
    end
  end
end
