defmodule Snowball.FollowTest do
  use Snowball.ModelCase

  alias Snowball.Follow

  test "changeset with valid attributes" do
    changeset = Follow.changeset(build(:follow), %{})
    assert changeset.valid?
  end

  # TODO: Bring this back. See https://github.com/elixir-lang/ecto/issues/1265
  # test "changeset with invalid attributes" do
  #   changeset = Follow.changeset(%Follow{}, %{})
  #   refute changeset.valid?
  # end
end
