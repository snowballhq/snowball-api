defmodule Snowball.User do
  use Snowball.Web, :model
  use Arc.Ecto.Schema

  alias Snowball.{Installation, Flag, Follow, Like, Repo}

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
    field :avatar, Snowball.UserAvatar.Type

    # has_many :follows, Follow
    # has_many :followeds, through: [:follows, :followed]
    # has_many :followers, through: [:follows, :follower]

    has_many :installations, Installation

    timestamps [inserted_at: :created_at]
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :email], [:password, :phone_number, :password_digest])
    |> maybe_cast_attachments(params)
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

  defp maybe_cast_attachments(struct, params) do
    cond do
      params[:avatar] || params["avatar"] ->
        struct |> cast_attachments(params, [:avatar])
      true -> struct
    end
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
    if phone_number_string = get_change(changeset, :phone_number) do
      case ExPhoneNumber.parse(phone_number_string, "US") do
        {:ok, phone_number} ->
          if ExPhoneNumber.is_valid_number?(phone_number) do
            changeset
          else
            changeset
            |> add_error(:phone_number, "is invalid")
          end
        {:error, _message} ->
          changeset
          |> add_error(:phone_number, "is invalid")
      end
    else
      changeset
    end
  end

  def follow_for(follower, followed) do
    Repo.get_by(Follow,
      follower_id: follower.id,
      followed_id: followed.id
    )
  end

  def following?(follower, followed) do
    if follow_for(follower, followed) do
      true
    else
      false
    end
  end

  def follow(follower, followed) do
    cond do
      follower.id == followed.id -> false
      follow_for(follower, followed) -> true
      true ->
        changeset = Follow.changeset(%Follow{}, %{
          follower_id: follower.id,
          followed_id: followed.id
        })
        case Repo.insert(changeset) do
          {:ok, _follow} -> true
          {:error, _changeset} -> false
        end
    end
  end

  def unfollow(follower, followed) do
    if follow = follow_for(follower, followed) do
      case Repo.delete(follow) do
        {:ok, _follow} -> true
        {:error, _changeset} -> false
      end
    else
      true
    end
  end

  def like_for(user, clip) do
    Repo.get_by(Like,
      user_id: user.id,
      clip_id: clip.id
    )
  end

  def likes?(user, clip) do
    if like_for(user, clip) do
      true
    else
      false
    end
  end

  def like(user, clip) do
    result = cond do
      like_for(user, clip) -> true
      true ->
        changeset = Like.changeset(%Like{}, %{
          user_id: user.id,
          clip_id: clip.id
        })
        case Repo.insert(changeset) do
          {:ok, _like} -> true
          {:error, _changeset} -> false
        end
    end
    if result do
      clip_user = assoc(clip, :user)
      send_push_notification(user, "#{user.username} liked your clip. 👍")
    end
    result
  end

  def unlike(user, clip) do
    if like = like_for(user, clip) do
      case Repo.delete(like) do
        {:ok, _like} -> true
        {:error, _changeset} -> false
      end
    else
      true
    end
  end

  def flag(_user, clip) do
    changeset = Flag.changeset(%Flag{}, %{
      clip_id: clip.id
    })
    case Repo.insert(changeset) do
      {:ok, _flag} -> true
      {:error, _changeset} -> false
    end
  end

  def send_push_notification(user, message) do
    assoc(user, :installations) |> Repo.all |> Enum.each(fn(installation) ->
      Snowball.PushNotificationService.send_push_to_installation_arn(message, installation.arn)
    end)
  end
end
