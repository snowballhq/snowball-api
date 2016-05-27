defmodule Snowball.FollowTest do
  use Snowball.ModelCase

  alias Snowball.Follow

  test "changeset/2" do
    assert "can't be blank" in errors_on(%Follow{}, :follower_id)
    assert "can't be blank" in errors_on(%Follow{}, :following_id)
  end
end
