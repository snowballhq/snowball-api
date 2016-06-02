defmodule Snowball.FollowTest do
  use Snowball.ModelCase, async: true

  test "changeset/2" do
    assert "can't be blank" in errors_on(%Follow{}, :follower_id)
    assert "can't be blank" in errors_on(%Follow{}, :followed_id)
  end
end
