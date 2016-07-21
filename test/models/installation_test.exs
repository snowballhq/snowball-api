defmodule Snowball.InstallationTest do
  use Snowball.ModelCase, async: true

  test "changeset/2" do
    assert "can't be blank" in errors_on(%Installation{}, :user_id)
    assert "can't be blank" in errors_on(%Installation{}, :arn)
  end
end
