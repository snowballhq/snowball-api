defmodule Snowball.User do
  use Snowball.BaseModel

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
    |> cast(params, [:username, :email], [:password, :phone_number, :password_digest])
    |> hash_password
    |> generate_auth_token
    |> validate_required([:email, :username, :auth_token])
    |> validate_format(:email, ~r/\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/)
    |> validate_format(:username, ~r/\A[a-zA-Z0-9_]{3,15}\z/)
    |> validate_length(:username, min: 3, max: 15)
    |> validate_length(:password, min: 5)
    |> validate_phone_number
    |> unique_constraint(:email, name: :index_users_on_email)
    |> unique_constraint(:username, name: :index_users_on_username)
    |> unique_constraint(:auth_token, name: :index_users_on_auth_token)
  end

  def registration_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, [:password], [])
    |> validate_required([:password])
  end

  defp hash_password(changeset) do
    if password = get_change(changeset, :password) do
      changeset
      |> put_change(:password_digest, Comeonin.Bcrypt.hashpwsalt(password))
    else
      changeset
    end
  end

  defp generate_auth_token(changeset) do
    if get_field(changeset, :auth_token) do
      changeset
    else
      length = 20
      rlength = (length * 3) / 4
      auth_token = SecureRandom.urlsafe_base64(round(rlength))

      auth_token
      |> String.replace("lIO0", "sxyz")
      |> String.replace("l", "s")
      |> String.replace("I", "x")
      |> String.replace("O", "y")
      |> String.replace("0", "z")

      changeset
      |> put_change(:auth_token, auth_token)
    end
  end

  defp validate_phone_number(changeset) do
    changeset
    # if phone_number_string = get_change(changeset, :phone_number) do
    #   case ExPhoneNumber.parse(phone_number_string, "US") do
    #     {:ok, phone_number} ->
    #       if ExPhoneNumber.is_valid_number?(phone_number) do
    #         changeset
    #       else
    #         changeset
    #         |> add_error(:phone_number, "is invalid")
    #       end
    #     {:error, _message} ->
    #       changeset
    #       |> add_error(:phone_number, "is invalid")
    #   end
    # else
    #   changeset
    # end
  end
end
