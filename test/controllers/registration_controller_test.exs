defmodule Snowball.RegistrationControllerTest do
  use Snowball.ConnCase, async: true

  test "create/2 creates a new user", %{conn: conn} do
    params = params_for(:user_before_registration)
    conn = post conn, registration_path(conn, :create), params
    user = Repo.one(from x in User, order_by: [desc: x.id], limit: 1) # Last user
    assert json_response(conn, 201) == user_auth_response(user)
  end

  test "create/2 with a taken username (case insensitive) returns an error", %{conn: conn} do
    user = insert(:user)
    params = params_for(:user_before_registration, username: user.username |> String.upcase)
    conn = post conn, registration_path(conn, :create), params
    assert json_response(conn, 422) == error_changeset_response(:username, "has already been taken")
  end

  test "create/2 with an invalid username returns an error", %{conn: conn} do
    params = params_for(:user_before_registration, username: "a")
    conn = post conn, registration_path(conn, :create), params
    assert json_response(conn, 422) == error_changeset_response(:username, "should be at least 3 characters")
  end

  test "create/2 with a taken email (case insensitive) returns an error", %{conn: conn} do
    user = insert(:user)
    params = params_for(:user_before_registration, email: user.email |> String.upcase)
    conn = post conn, registration_path(conn, :create), params
    assert json_response(conn, 422) == error_changeset_response(:email, "has already been taken")
  end

  test "create/2 with an invalid email returns an error", %{conn: conn} do
    params = params_for(:user_before_registration, email: "a")
    conn = post conn, registration_path(conn, :create), params
    assert json_response(conn, 422) == error_changeset_response(:email, "has invalid format")
  end

  test "create/2 with an invalid password returns an error", %{conn: conn} do
    params = params_for(:user_before_registration, password: "")
    conn = post conn, registration_path(conn, :create), params
    assert json_response(conn, 422) == error_changeset_response(:password, "should be at least 5 characters")
  end
end
