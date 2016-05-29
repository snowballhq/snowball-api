defmodule Snowball.UserControllerTest do
  use Snowball.ConnCase, async: true

  test_authentication_required_for(:get, :user_path, :show, "696c7ceb-c8ec-4f2b-a16a-21c822c9e984")

  test "show/2 returns the user if the user exists", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> authenticate(user.auth_token)
    |> get(user_path(conn, :show, user))
    assert json_response(conn, 200) == user_response(user)
  end

  test "show/2 returns a 404 if the user does not exist", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> authenticate(user.auth_token)
    |> get(user_path(conn, :show, "696c7ceb-c8ec-4f2b-a16a-21c822c9e984"))
    assert json_response(conn, 404) == error_not_found_response
  end

  test_authentication_required_for(:patch, :user_path, :update, "696c7ceb-c8ec-4f2b-a16a-21c822c9e984")

  test "update/2 updates and returns the user if the user exists", %{conn: conn} do
    user = insert(:user)
    params = %{email: "example@example.com"}
    conn = conn
    |> authenticate(user.auth_token)
    |> patch(user_path(conn, :update, user), user: params)
    user = Repo.get(User, user.id)
    assert user.email == params[:email]
    assert json_response(conn, 200) == user_response(user)
  end

  test "update/2 does not update the user if unauthorized", %{conn: conn} do
    user = insert(:user)
    user_to_update = insert(:user)
    params = %{email: "example@example.com"}
    conn = conn
    |> authenticate(user.auth_token)
    |> patch(user_path(conn, :update, user_to_update), user: params)
    user = Repo.get(User, user.id)
    assert user.email != params[:email]
    assert json_response(conn, 401) == error_unauthorized_response
  end

  test "update/2 does not update and returns an error if a param is invalid", %{conn: conn} do
    user = insert(:user)
    params = %{email: "example"}
    conn = conn
    |> authenticate(user.auth_token)
    |> patch(user_path(conn, :update, user), user: params)
    user = Repo.get(User, user.id)
    refute user.email == params[:email]
    assert json_response(conn, 422) == error_changeset_response(:email, "has invalid format")
  end
end
