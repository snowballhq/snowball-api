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

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(username email), ~w(password))
    |> hash_password
    |> generate_auth_token
    |> validate_required([:email, :username, :auth_token])
    |> validate_format(:email, ~r/\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/)
    |> validate_format(:username, ~r/\A[a-zA-Z0-9_]{3,15}\z/)
    |> validate_length(:username, min: 3, max: 15)
    |> validate_length(:password, min: 5)
    |> unique_constraint(:email) # TODO: should be case insensitive
    |> unique_constraint(:username) # TODO: should be case insensitive
    |> unique_constraint(:auth_token)
  end

  def registration_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> validate_required([:password])
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
