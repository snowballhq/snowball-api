defmodule Snowball.UserRequestsTest do
  use Snowball.ConnCase, async: true

  test "GET /users/:id" do
    user = insert(:user)
    conn = conn(:get, "/users/#{user.id}")
    assert conn |> json_response(200) == User.json(user)
  end

  test "GET /users/:id with an invalid id returns an error" do
    conn = conn(:get, "/users/#{generic_uuid}")
    assert conn |> head_response(404)
  end

  test "PATCH /users/:id with valid params updates the user" do
    user = insert(:user)
    conn = conn(:patch, "/users/#{user.id}", email: "example@example.com")
    assert conn |> json_response(200) == User.json(user)
    assert Repo.get(User, user.id).email == "example@example.com"
  end

  test "PATCH /users/:id with an invalid id returns an error" do
    conn = conn(:patch, "/users/#{generic_uuid}")
    assert conn |> head_response(404)
  end

  test "PATCH /users/:id with an invalid params returns an error" do
    user = insert(:user)
    conn = conn(:patch, "/users/#{user.id}", email: "example")
    assert conn |> json_response(422) == ChangesetErrorsHelper.json_for_error(email: "has invalid format")
    assert Repo.get(User, user.id).email == user.email
  end
end
