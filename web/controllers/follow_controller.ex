defmodule Snowball.FollowController do
  use Snowball.Web, :controller

  alias Snowball.User

  plug Snowball.Plug.Authenticate when action in [:create, :delete]

  def create(conn, %{"user_id" => user_id}) do
    follower = conn.assigns.current_user
    followed = Repo.get(User, user_id)
    if followed do
      User.follow(follower, followed)
      conn
      |> put_status(:created)
      |> render(Snowball.UserView, "show.json", user: followed)
    end
  end

  def delete(conn, %{"user_id" => user_id}) do
    follower = conn.assigns.current_user
    followed = Repo.get(User, user_id)
    if followed do
      User.unfollow(follower, followed)
      conn
      |> put_status(:ok) # TODO: Should this status be something else?
      |> render(Snowball.UserView, "show.json", user: followed)
    end
  end
end
