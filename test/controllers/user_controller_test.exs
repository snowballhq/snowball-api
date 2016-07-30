defmodule Snowball.UserControllerTest do
  use Snowball.ConnCase, async: true

  test_authentication_required_for(:get, :user_path, :show, generic_uuid)

  test "show/2 returns the user if the user exists", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> authenticate(user.auth_token)
    |> get(user_path(conn, :show, user))
    assert json_response(conn, 200) == user_response(user, current_user: user)
  end

  test "show/2 returns a 404 if the user does not exist", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> authenticate(user.auth_token)
    |> get(user_path(conn, :show, generic_uuid))
    assert json_response(conn, 404) == error_not_found_response
  end

  test_authentication_required_for(:patch, :user_path, :update)

  test "update/2 updates (formatting phone numbers) and returns the current user", %{conn: conn} do
    user = insert(:user)
    params = %{email: "example@example.com", phone_number: "3344434159"}
    conn = conn
    |> authenticate(user.auth_token)
    |> patch(user_path(conn, :update), params)
    user = Repo.get(User, user.id)
    assert user.email == params[:email]
    assert user.phone_number == "+13344434159" # Ensure format saved as E.164
    assert json_response(conn, 200) == user_response(user, current_user: user)
  end

  test "update/2 does not update and returns an error if a param is invalid", %{conn: conn} do
    user = insert(:user)
    params = %{email: "example"}
    conn = conn
    |> authenticate(user.auth_token)
    |> patch(user_path(conn, :update), params)
    user = Repo.get(User, user.id)
    refute user.email == params[:email]
    assert json_response(conn, 422) == error_changeset_response(:email, "has invalid format")
  end

  test_authentication_required_for(:post, :user_search_path, :search)

  test "search/2 when provided phone numbers return users where phone number matches without current user", %{conn: conn} do
    user = insert(:user, phone_number: "+14151234567")
    user1 = insert(:user, phone_number: "+13344434159")
    user2 = insert(:user, phone_number: "+19786951682")
    params = %{
      phone_numbers: [
        # Testing phone number search when params number formatting not E.164
        user.phone_number,
        "+13344434159",
        "(978)695-1682",
        "test"
      ]
    }
    conn = conn
    |> authenticate(user.auth_token)
    |> post(user_search_path(conn, :search), params)
    assert json_response(conn, 200) == [user_response(user1, current_user: user), user_response(user2, current_user: user)]
  end

  test "search/2 when provided username return users where username matches without current user", %{conn: conn} do
    current_user = insert(:user)
    user = insert(:user)
    # Slice the last 2 characters off the username and upcase to test "like" search
    username = String.slice(user.username, 0..String.length(user.username)-3) |> String.upcase
    params = %{
      username: username
    }
    conn = conn
    |> authenticate(current_user.auth_token)
    |> post(user_search_path(conn, :search), params)
    assert json_response(conn, 200) == [user_response(user, current_user: current_user)]
  end

  test "search/2 is paginated", %{conn: conn} do
    user = insert(:user)
    for i <- 0..25, do: insert(:user, username: "user#{i}")
    conn = conn
    |> authenticate(user.auth_token)
    |> post(user_search_path(conn, :search, page: 2), %{username: "user"})
    assert Enum.count(json_response(conn, 200)) == 1
  end

  test_authentication_required_for(:get, :user_recommended_path, :recommended)

  test "recommended/2 returns friends of friends of the current user", %{conn: conn} do
    user = insert(:user)
    user1 = insert(:follow, follower: user).followed
    user2 = insert(:follow, follower: user1).followed
    insert(:follow, follower: user1, followed: user) # Current user should not be in response
    conn = conn
    |> authenticate(user.auth_token)
    |> get(user_recommended_path(conn, :recommended))
    assert json_response(conn, 200) == [user_response(user2, current_user: user)]
  end

  test "recommended/2 is paginated", %{conn: conn} do
    user = insert(:user)
    user1 = insert(:follow, follower: user).followed
    for _ <- 0..25, do: insert(:follow, follower: user1).followed
    conn = conn
    |> authenticate(user.auth_token)
    |> get(user_recommended_path(conn, :recommended, page: 2))
    assert Enum.count(json_response(conn, 200)) == 1
  end
end
