defmodule Snowball.UserTest do
  use Snowball.ModelCase

  alias Snowball.User

  test "insert changeset with valid attributes" do
    changeset = User.insert_changeset(build(:user_before_registration), %{})
    assert changeset.valid?
  end

  test "insert changeset with invalid attributes" do
    changeset = User.insert_changeset(%User{}, %{})
    refute changeset.valid?
  end

  test "update changeset with valid attributes" do
    changeset = User.update_changeset(build(:user), %{})
    assert changeset.valid?
  end

  test "update changeset with invalid attributes" do
    changeset = User.update_changeset(%User{}, %{})
    refute changeset.valid?
  end
end
