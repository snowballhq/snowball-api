defmodule Snowball.FollowTest do
  use Snowball.ModelCase

  alias Snowball.Follow

  test "changeset validations" do
    assert {:follower_id, "can't be blank"} in errors_on(%Follow{}, %{})
    assert {:following_id, "can't be blank"} in errors_on(%Follow{}, %{})
  end
end
