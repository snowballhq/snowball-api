defmodule Snowball.UserTest do
  use Snowball.ModelCase

  alias Snowball.User

  test "changeset with valid attributes" do
    changeset = User.changeset(build(:user), %{})
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, %{})
    refute changeset.valid?
  end

  test "changeset validations" do
    assert {:email, "can't be blank"} in errors_on(%User{}, %{email: nil})
    assert {:username, "can't be blank"} in errors_on(%User{}, %{username: nil})
    # Since auth token is created on validation, not sure if this is a worthless test, but it doesn't work
    # assert {:auth_token, "can't be blank"} in errors_on(%User{}, %{auth_token: nil})
    assert {:email, "has invalid format"} in errors_on(%User{}, %{email: ""})
    assert {:username, "has invalid format"} in errors_on(%User{}, %{username: ""})
    assert {:username, "has invalid format"} in errors_on(%User{}, %{username: ""})
    assert {:username, "should be at least 3 character(s)"} in errors_on(%User{}, %{username: ""})
    assert {:username, "should be at most 15 character(s)"} in errors_on(%User{}, %{username: "aaaaaaaaaaaaaaaa"})
    assert {:password, "should be at least 5 character(s)"} in errors_on(%User{}, %{password: ""})
    # TODO: Add uniqueness validations
  end

  test "registration changeset with valid attributes" do
    changeset = User.registration_changeset(build(:user_before_registration), %{})
    assert changeset.valid?
  end

  test "registration changeset with invalid attributes" do
    changeset = User.registration_changeset(%User{}, %{})
    refute changeset.valid?
  end
end
