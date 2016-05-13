defmodule Snowball.UserControllerTest do
  use Snowball.ConnCase

  alias Snowball.User
  @valid_attrs %{email: "some content", username: "some content"}
  @invalid_attrs %{}

  # TODO: Convert these tests to use ex_machina (Factory Girl alternative)

  test "GET /users" do
    user = new_user
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, 200)["data"] == [user_response(user)]
  end

  test "GET /users/:id" do
    user = new_user
    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, 200)["data"] == user_response(user)
  end

  # TODO: Figure out error handling
  test "GET /users/:id with invalid params" do
    # assert_error_sent 404, fn ->
    #   get conn, user_path(conn, :show, -1)
    # end
  end

  test "POST /users" do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    user = Repo.get_by(User, @valid_attrs)
    assert user
    assert json_response(conn, 201)["data"] == user_response(user)
  end

  # TODO: Figure out error handling
  test "POST /users with invalid params" do
    # conn = post conn, user_path(conn, :create), user: @invalid_attrs
    # assert json_response(conn, 422)["errors"] != %{}
  end

  # TODO: This should probably check real changes to the user, once
  # ex_machina is in
  test "PATCH /users/:id" do
    user = new_user
    conn = patch conn, user_path(conn, :update, user), user: @valid_attrs
    user = Repo.get_by(User, @valid_attrs)
    assert user
    assert json_response(conn, 200)["data"] == user_response(user)
  end

  # TODO: Figure out error handling
  test "PATCH /users/:id with invalid params" do
    # user = Repo.insert! %User{}
    # conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    # assert json_response(conn, 422)["errors"] != %{}
  end

  test "DELETE /users/:id" do
    user = new_user
    conn = delete conn, user_path(conn, :delete, user)
    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end

  # TODO: Figure out error handling
  test "DELETE /users/:id with invalid params" do
  end

  defp new_user do
    changeset = User.changeset(%User{}, @valid_attrs)
    Repo.insert! changeset
  end

  defp user_response(user) do
    %{"id" => user.id,
    "username" => user.username,
    "email" => user.email}
  end
end
