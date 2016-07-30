defmodule Snowball.UserController do
  use Snowball.Web, :controller

  alias Snowball.User

  plug Snowball.Plug.Authenticate when action in [:show, :update, :search, :recommended]

  def show(conn, %{"id" => id}) do
    if user = Repo.get(User, id) do
      render(conn, "show.json", user: user)
    else
      conn
      |> put_status(:not_found)
      |> render(Snowball.ErrorView, "404.json")
    end
  end

  def update(conn, params) do
    user = conn.assigns.current_user
    changeset = User.changeset(user, params)
    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Snowball.ErrorView, "error.json", changeset: changeset)
    end
  end

  def search(conn, params) do
    users = cond do
      phone_numbers = params["phone_numbers"] ->
        e164_phone_numbers = Enum.map(phone_numbers, fn(phone_number_string) ->
          case ExPhoneNumber.parse(phone_number_string, "US") do
            {:ok, phone_number} -> ExPhoneNumber.format(phone_number, :e164)
            {:error, _ } -> nil
          end
        end)
        query = User |> where([u], u.phone_number in ^e164_phone_numbers)
      username = params["username"] -> query = from u in User, where: ilike(u.username, ^"%#{username}%")
    end
    |> Snowball.Paginator.page(params["page"])
    |> Repo.all
    |> List.delete(conn.assigns.current_user)
    render(conn, "index.json", users: users)
  end

  def recommended(conn, params) do
    user = conn.assigns.current_user

    user_ids_following = Repo.all(
      from f in Snowball.Follow,
      select: f.followed_id,
      where: f.follower_id == ^user.id
    )

    recommended_user_ids = Repo.all(
      from f in Snowball.Follow,
      join: f2 in Snowball.Follow, on: f.followed_id == f2.follower_id,
      where: f.follower_id == ^user.id,
      where: f2.followed_id != ^user.id,
      where: not(f2.followed_id in ^user_ids_following),
      select: f2.followed_id
    )

    users =
      User
      |> where([u], u.id in ^recommended_user_ids)
      |> Snowball.Paginator.page(params["page"])
      |> Repo.all

    render(conn, "index.json", users: users)
  end
end
