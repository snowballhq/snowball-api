defmodule Snowball.FollowController do
  use Snowball.Web, :controller

  alias Snowball.User

  plug Snowball.Plug.Authenticate when action in [:create, :delete]

  def create(conn, %{"id" => id}) do
    follower = conn.assigns.current_user
    followed = Repo.get(User, id)
    if followed do
      User.follow(follower, followed)
      conn
      |> put_status(:created)
      |> render(Snowball.UserView, "show.json", user: followed)
    end
  end

  def delete(conn, %{"id" => id}) do
    follower = conn.assigns.current_user
    followed = Repo.get(User, id)
    if followed do
      User.unfollow(follower, followed)
      render(conn, Snowball.UserView, "show.json", user: followed)
    end
  end
end
