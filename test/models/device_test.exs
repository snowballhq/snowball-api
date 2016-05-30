defmodule Snowball.DeviceTest do
  use Snowball.ModelCase, async: true

  test "changeset/2" do
    assert "can't be blank" in errors_on(%Device{}, :user_id)
    assert "can't be blank" in errors_on(%Device{}, :arn)
  end
end
