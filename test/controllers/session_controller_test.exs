defmodule Snowball.SessionControllerTest do
  use Snowball.ConnCase

  test "POST /users/sign-up", %{conn: conn} do
    password = "somepassword"
    user = insert(:user, %{password_digest: Comeonin.Bcrypt.hashpwsalt(password)})
    conn = post conn, session_path(conn, :create), user: %{email: user.email, password: password}
    assert json_response(conn, 201) == user_auth_response(user)
  end

  test "POST /users/sign-up with invalid password", %{conn: conn} do
    user = insert(:user, %{password_digest: Comeonin.Bcrypt.hashpwsalt("password")})
    conn = post conn, session_path(conn, :create), user: %{email: user.email, password: "anotherpassword"}
    assert json_response(conn, 401) == %{"message" => "Invalid password"}
  end

  test "POST /users/sign-up with invalid email", %{conn: conn} do
    password = "somepassword"
    insert(:user, %{password_digest: Comeonin.Bcrypt.hashpwsalt(password)})
    conn = post conn, session_path(conn, :create), user: %{email: "wrongemail", password: password}
    assert json_response(conn, 401) == %{"message" => "Invalid email"}
  end

  defp user_auth_response(user) do
    %{"id" => user.id,
    "username" => user.username,
    "email" => user.email,
    "auth_token" => user.auth_token}
  end
end
