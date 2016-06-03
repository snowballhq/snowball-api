defmodule Snowball.LikeTest do
  use Snowball.ModelCase, async: true

  test "changeset/2" do
    assert "can't be blank" in errors_on(%Like{}, :user_id)
    assert "can't be blank" in errors_on(%Like{}, :clip_id)
  end
end
