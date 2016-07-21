defmodule Snowball.FollowController do
  use Snowball.Web, :controller

  alias Snowball.User

  plug Snowball.Plug.Authenticate when action in [:create, :delete, :following, :followers]

  def create(conn, %{"user_id" => id}) do
    follower = conn.assigns.current_user
    if followed = Repo.get(User, id) do
      if User.follow(follower, followed) do
        conn
        |> put_status(:created)
        |> render(Snowball.UserView, "show.json", user: followed)
      else
        conn
        |> put_status(:bad_request)
        |> render(Snowball.ErrorView, "400.json")
      end
    else
      conn
      |> put_status(:bad_request)
      |> render(Snowball.ErrorView, "400.json")
    end
  end

  def delete(conn, %{"user_id" => id}) do
    follower = conn.assigns.current_user
    if followed = Repo.get(User, id) do
      if User.unfollow(follower, followed) do
        render(conn, Snowball.UserView, "show.json", user: followed)
      else
        conn
        |> put_status(:bad_request)
        |> render(Snowball.ErrorView, "400.json")
      end
    else
      conn
      |> put_status(:bad_request)
      |> render(Snowball.ErrorView, "400.json")
    end
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
      render(conn, Snowball.UserView, "index.json", users: followed)
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
      render(conn, Snowball.UserView, "index.json", users: followers)
    else
      conn
      |> put_status(:not_found)
      |> render(Snowball.ErrorView, "404.json")
    end
  end
end
