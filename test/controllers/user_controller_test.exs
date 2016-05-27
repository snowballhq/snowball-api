defmodule Snowball.UserControllerTest do
  use Snowball.ConnCase, async: true

  alias Snowball.User

  test "GET /users/:id", %{conn: conn} do
    user = insert(:user)
    conn = conn |> authenticate(user.auth_token)
    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, 200) == user_response(user)
  end

  # TODO: Figure out error handling
  test "GET /users/:id with invalid params", %{conn: _conn} do
    # assert_error_sent 404, fn ->
    #   get conn, user_path(conn, :show, -1)
    # end
  end

  test "PATCH /users/:id", %{conn: conn} do
    user = insert(:user)
    params = %{email: "example1@example.com"}
    conn = conn |> authenticate(user.auth_token)
    conn = patch conn, user_path(conn, :update, user), user: params
    user = Repo.get(User, user.id)
    assert json_response(conn, 200) == user_response(user)
  end

  # TODO: Figure out error handling
  test "PATCH /users/:id with invalid params", %{conn: _conn} do
    # user = Repo.insert! %User{}
    # conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    # assert json_response(conn, 422)["errors"] != %{}
  end

  defp user_response(user) do
    %{"id" => user.id,
    "username" => user.username,
    "email" => user.email}
  end
end
