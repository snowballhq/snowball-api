defmodule Snowball.RegistrationControllerTest do
  use Snowball.ConnCase, async: true

  alias Snowball.User

  test "POST /users/sign-up", %{conn: conn} do
    user_params = params_for(:user_before_registration)
    conn = post conn, registration_path(conn, :create), user: user_params
    user = Repo.one(from x in User, order_by: [desc: x.id], limit: 1)
    assert json_response(conn, 201) == user_auth_response(user)
  end

  # TODO: Figure out error handling
  test "POST /users/sign-up with invalid params", %{conn: _conn} do
    # conn = post conn, user_path(conn, :create), user: @invalid_attrs
    # assert json_response(conn, 422)["errors"] != %{}
  end

  defp user_auth_response(user) do
    %{"id" => user.id,
    "username" => user.username,
    "email" => user.email,
    "auth_token" => user.auth_token}
  end
end
