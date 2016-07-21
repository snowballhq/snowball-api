defmodule Snowball.UserController do
  use Snowball.Web, :controller

  alias Snowball.User

  plug Snowball.Plug.Authenticate when action in [:show, :update, :search, :following, :followers]

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
      phone_numbers = params["phone_numbers"] -> query = User |> where([u], u.phone_number in ^phone_numbers)
      username = params["username"] -> query = User |> where(username: ^username)
    end
    |> Repo.all
    |> List.delete(conn.assigns.current_user)
    render(conn, "index.json", users: users)
  end

  def following(conn, params) do
    if user = Repo.get(User, params["user_id"]) do
      query = from f in Snowball.Follow,
        join: u in User, on: f.followed_id == u.id,
        where: f.follower_id == ^user.id,
        select: u
      followed = query
      |> Snowball.Paginator.page(params["page"])
      |> Repo.all
      render(conn, "index.json", users: followed)
    else
      conn
      |> put_status(:not_found)
      |> render(Snowball.ErrorView, "404.json")
    end
  end

  def followers(conn, params) do
    if user = Repo.get(User, params["user_id"]) do
      query = from f in Snowball.Follow,
        join: u in User, on: f.follower_id == u.id,
        where: f.followed_id == ^user.id,
        select: u
      followers = query
      |> Snowball.Paginator.page(params["page"])
      |> Repo.all
      render(conn, "index.json", users: followers)
    else
      conn
      |> put_status(:not_found)
      |> render(Snowball.ErrorView, "404.json")
    end
  end
end
