defmodule Snowball.FollowControllerTest do
  use Snowball.ConnCase, async: true

  test_authentication_required_for(:put, :user_follow_path, :create, generic_uuid)

  test "create/2 when not following follows and returns the user", %{conn: conn} do
    follower = insert(:user)
    followed = insert(:user)
    conn = conn
    |> authenticate(follower.auth_token)
    |> put(user_follow_path(conn, :create, followed))
    assert json_response(conn, 201) == user_response(followed, current_user: follower)
    assert User.following?(follower, followed)
  end

  test "create/2 when already following returns the user", %{conn: conn} do
    follow = insert(:follow)
    conn = conn
    |> authenticate(follow.follower.auth_token)
    |> put(user_follow_path(conn, :create, follow.followed))
    assert json_response(conn, 201) == user_response(follow.followed, current_user: follow.follower)
    assert User.following?(follow.follower, follow.followed)
  end

  test "create/2 when trying to follow self returns an error", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> authenticate(user.auth_token)
    |> put(user_follow_path(conn, :create, user))
    assert json_response(conn, 400) == error_bad_request_response
  end

  test "create/2 when the user does not exist returns an error", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> authenticate(user.auth_token)
    |> put(user_follow_path(conn, :create, generic_uuid))
    assert json_response(conn, 400) == error_bad_request_response
  end

  test_authentication_required_for(:delete, :user_follow_path, :delete, generic_uuid)

  test "delete/2 when following unfollows and returns the user", %{conn: conn} do
    follow = insert(:follow)
    assert User.following?(follow.follower, follow.followed)
    conn = conn
    |> authenticate(follow.follower.auth_token)
    |> delete(user_follow_path(conn, :delete, follow.followed))
    assert json_response(conn, 200) == user_response(follow.followed, current_user: follow.follower)
    refute User.following?(follow.follower, follow.followed)
  end

  test "delete/2 when not following returns the user", %{conn: conn} do
    follower = insert(:user)
    followed = insert(:user)
    conn = conn
    |> authenticate(follower.auth_token)
    |> delete(user_follow_path(conn, :delete, followed))
    assert json_response(conn, 200) == user_response(followed, current_user: follower)
    refute User.following?(follower, followed)
  end

  test "delete/2 when the user does not exist returns an error", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> authenticate(user.auth_token)
    |> delete(user_follow_path(conn, :delete, generic_uuid))
    assert json_response(conn, 400) == error_bad_request_response
  end

  test_authentication_required_for(:get, :user_following_path, :following, generic_uuid)

  test "following/2 when the user exists returns a list of users that the user is following", %{conn: conn} do
    follow = insert(:follow)
    conn = conn
    |> authenticate(follow.follower.auth_token)
    |> get(user_following_path(conn, :following, follow.follower))
    assert json_response(conn, 200) == [user_response(follow.followed, current_user: follow.follower)]
  end

  test "following/2 is paginated", %{conn: conn} do
    user = insert(:user)
    for _ <- 0..25, do: insert(:follow, follower: user)
    conn = conn
    |> authenticate(user.auth_token)
    |> get(user_following_path(conn, :following, user, page: 2))
    assert Enum.count(json_response(conn, 200)) == 1
  end

  test "following/2 when the user does not exist returns an error", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> authenticate(user.auth_token)
    |> get(user_following_path(conn, :following, generic_uuid))
    assert json_response(conn, 404) == error_not_found_response
  end

  test_authentication_required_for(:get, :user_followers_path, :followers, generic_uuid)

  test "followers/2 when the user exists returns a list of users that are following the user", %{conn: conn} do
    follow = insert(:follow)
    conn = conn
    |> authenticate(follow.followed.auth_token)
    |> get(user_followers_path(conn, :followers, follow.followed))
    assert json_response(conn, 200) == [user_response(follow.follower, current_user: follow.followed)]
  end

  test "followers/2 is paginated", %{conn: conn} do
    user = insert(:user)
    for _ <- 0..25, do: insert(:follow, followed: user)
    conn = conn
    |> authenticate(user.auth_token)
    |> get(user_followers_path(conn, :followers, user, page: 2))
    assert Enum.count(json_response(conn, 200)) == 1
  end

  test "followers/2 when the user does not exist returns an error", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> authenticate(user.auth_token)
    |> get(user_followers_path(conn, :followers, generic_uuid))
    assert json_response(conn, 404) == error_not_found_response
  end
end
