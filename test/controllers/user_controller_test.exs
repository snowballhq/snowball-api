defmodule Snowball.UserControllerTest do
  use Snowball.ConnCase, async: true

  alias Snowball.User

  test "GET /users", %{conn: conn} do
    user = insert(:user)
    conn = conn |> authenticate(user.auth_token)
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, 200) == [user_response(user)]
  end

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

  test "POST /users", %{conn: conn} do
    user_params = params_for(:user_before_registration)
    conn = post conn, user_path(conn, :create), user: user_params
    user = Repo.one(from x in User, order_by: [desc: x.id], limit: 1)
    assert json_response(conn, 201) == user_response(user)
  end

  # TODO: Figure out error handling
  test "POST /users with invalid params", %{conn: _conn} do
    # conn = post conn, user_path(conn, :create), user: @invalid_attrs
    # assert json_response(conn, 422)["errors"] != %{}
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

  test "DELETE /users/:id", %{conn: conn} do
    user = insert(:user)
    conn = conn |> authenticate(user.auth_token)
    conn = delete conn, user_path(conn, :delete, user)
    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end

  # TODO: Figure out error handling
  test "DELETE /users/:id with invalid params", %{conn: _conn} do
  end

  defp user_response(user) do
    %{"id" => user.id,
    "username" => user.username,
    "email" => user.email}
  end
end
