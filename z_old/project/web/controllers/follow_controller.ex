defmodule Snowball.FollowController do
  use Snowball.Web, :controller

  alias Snowball.User

  plug Snowball.Plug.Authenticate when action in [:create, :delete]

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
end
