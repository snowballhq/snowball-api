defmodule Snowball.FollowControllerTest do
  use Snowball.ConnCase

  alias Snowball.User

  test "POST /users/:id/follows", %{conn: conn} do
    follower = insert(:user)
    followed = insert(:user)
    refute User.following?(follower, followed)
    conn = conn |> authenticate(follower.auth_token)
    conn = post conn, user_follow_path(conn, :create, followed)
    assert json_response(conn, 201)["data"] == user_response(followed)
    assert User.following?(follower, followed)
  end

  # TODO: Figure out error handling
  # test "POST /users/:id/follows with invalid params", %{conn: conn} do
  # end

  test "DELETE /users/:id/follows", %{conn: conn} do
    follow = insert(:follow)
    follower = follow.follower
    followed = follow.following
    assert User.following?(follower, followed)
    conn = conn |> authenticate(follower.auth_token)
    conn = delete conn, user_follow_path(conn, :delete, followed)
    assert json_response(conn, 200)["data"] == user_response(followed)
    refute User.following?(follower, followed)
  end

  # TODO: Figure out error handling
  # test "DELETE /users/:id/follows with invalid params", %{conn: conn} do
  # end

  defp user_response(user) do
    %{"id" => user.id,
    "username" => user.username,
    "email" => user.email}
  end
end
