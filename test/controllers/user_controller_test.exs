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

  test "update/2 updates and returns the current user", %{conn: conn} do
    user = insert(:user)
    params = %{email: "example@example.com"}
    conn = conn
    |> authenticate(user.auth_token)
    |> patch(user_path(conn, :update), params)
    user = Repo.get(User, user.id)
    assert user.email == params[:email]
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
    user1 = insert(:user, phone_number: "3344434159")
    user2 = insert(:user, phone_number: "9786951682")
    params = %{
      phone_numbers: [
        user1.phone_number,
        user2.phone_number
      ]
    }
    conn = conn
    |> authenticate(user1.auth_token)
    |> post(user_search_path(conn, :search), params)
    assert json_response(conn, 200) == [user_response(user2, current_user: user1)]
  end

  test "search/2 when provided username return users where username matches without current user", %{conn: conn} do
    current_user = insert(:user)
    user = insert(:user)
    params = %{
      username: user.username
    }
    conn = conn
    |> authenticate(current_user.auth_token)
    |> post(user_search_path(conn, :search), params)
    assert json_response(conn, 200) == [user_response(user, current_user: current_user)]
  end
end
