defmodule Snowball.FlagTest do
  use Snowball.ModelCase, async: true

  test "changeset/2" do
    assert "can't be blank" in errors_on(%Flag{}, :clip_id)
  end
end
