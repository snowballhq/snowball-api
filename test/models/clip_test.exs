defmodule Snowball.ClipTest do
  use Snowball.ModelCase, async: true

  test "changeset/2" do
    assert "can't be blank" in errors_on(%Clip{}, :video)
    assert "can't be blank" in errors_on(%Clip{}, :user_id)
  end
end
