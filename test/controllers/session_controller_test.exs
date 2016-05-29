defmodule Snowball.SessionControllerTest do
  use Snowball.ConnCase, async: true

  test "create/2 returns the user with an auth token", %{conn: conn} do
    password = "password"
    user = insert(:user, %{password_digest: Comeonin.Bcrypt.hashpwsalt(password)})
    conn = post conn, session_path(conn, :create), user: %{email: user.email, password: password}
    assert json_response(conn, 201) == user_auth_response(user)
  end

  test "create/2 with an invalid email returns an error", %{conn: conn} do
    user = insert(:user)
    conn = post conn, session_path(conn, :create), user: %{email: "wrongemail", password: user.password}
    assert json_response(conn, 401) == %{"message" => "Invalid email"}
  end

  test "create/2 with an invalid password returns an error", %{conn: conn} do
    user = insert(:user, %{password_digest: Comeonin.Bcrypt.hashpwsalt("password")})
    conn = post conn, session_path(conn, :create), user: %{email: user.email, password: "wrongpassword"}
    assert json_response(conn, 401) == %{"message" => "Invalid password"}
  end
end
