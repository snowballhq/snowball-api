defmodule Snowball.SessionControllerTest do
  use Snowball.ConnCase

  test "POST /users/sign-up" do
    password = "somepassword"
    user = insert(:user, %{password_digest: Comeonin.Bcrypt.hashpwsalt(password)})
    conn = post conn, session_path(conn, :create), user: %{email: user.email, password: password}
    assert json_response(conn, 201)["data"] == user_auth_response(user)
  end

  test "POST /users/sign-up with invalid password" do
    user = insert(:user, %{password_digest: Comeonin.Bcrypt.hashpwsalt("password")})
    conn = post conn, session_path(conn, :create), user: %{email: user.email, password: "anotherpassword"}
    assert json_response(conn, 401)["error"] == %{"message" => "Invalid password"}
  end

  test "POST /users/sign-up with invalid email" do
    password = "somepassword"
    insert(:user, %{password_digest: Comeonin.Bcrypt.hashpwsalt(password)})
    conn = post conn, session_path(conn, :create), user: %{email: "wrongemail", password: password}
    assert json_response(conn, 401)["error"] == %{"message" => "Invalid email"}
  end

  defp user_auth_response(user) do
    %{"id" => user.id,
    "username" => user.username,
    "email" => user.email,
    "auth_token" => user.auth_token}
  end
end
