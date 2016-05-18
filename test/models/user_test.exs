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
end
