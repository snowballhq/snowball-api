defmodule Snowball.FollowControllerTest do
  use Snowball.ConnCase, async: true

  test_authentication_required_for(:put, :follow_path, :create, generic_uuid)

  test "create/2 when not following follows and returns the user", %{conn: conn} do
    follower = insert(:user)
    followed = insert(:user)
    conn = conn
    |> authenticate(follower.auth_token)
    |> put(follow_path(conn, :create, followed))
    assert json_response(conn, 201) == user_response(followed)
    assert User.following?(follower, followed)
  end

  test "create/2 when already following returns the user", %{conn: conn} do
    follow = insert(:follow)
    conn = conn
    |> authenticate(follow.follower.auth_token)
    |> put(follow_path(conn, :create, follow.following))
    assert json_response(conn, 201) == user_response(follow.following)
    assert User.following?(follow.follower, follow.following)
  end

  test "create/2 when trying to follow self returns an error", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> authenticate(user.auth_token)
    |> put(follow_path(conn, :create, user))
    assert json_response(conn, 400) == error_bad_request_response
  end

  test "create/2 when the user does not exist returns an error", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> authenticate(user.auth_token)
    |> put(follow_path(conn, :create, generic_uuid))
    assert json_response(conn, 400) == error_bad_request_response
  end

  test_authentication_required_for(:delete, :follow_path, :delete, generic_uuid)

  test "delete/2 when following unfollows and returns the user", %{conn: conn} do
    follow = insert(:follow)
    assert User.following?(follow.follower, follow.following)
    conn = conn
    |> authenticate(follow.follower.auth_token)
    |> delete(follow_path(conn, :delete, follow.following))
    assert json_response(conn, 200) == user_response(follow.following)
    refute User.following?(follow.follower, follow.following)
  end

  test "delete/2 when not following returns the user", %{conn: conn} do
    follower = insert(:user)
    followed = insert(:user)
    conn = conn
    |> authenticate(follower.auth_token)
    |> delete(follow_path(conn, :delete, followed))
    assert json_response(conn, 200) == user_response(followed)
    refute User.following?(follower, followed)
  end

  test "delete/2 when the user does not exist returns an error", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> authenticate(user.auth_token)
    |> delete(follow_path(conn, :delete, generic_uuid))
    assert json_response(conn, 400) == error_bad_request_response
  end
end
