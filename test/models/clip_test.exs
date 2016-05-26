defmodule Snowball.ClipTest do
  use Snowball.ModelCase

  alias Snowball.Clip

  test "changeset validations" do
    assert {:video_file_name, "can't be blank"} in errors_on(%Clip{}, %{})
    assert {:video_content_type, "can't be blank"} in errors_on(%Clip{}, %{})
    assert {:thumbnail_file_name, "can't be blank"} in errors_on(%Clip{}, %{})
    assert {:thumbnail_content_type, "can't be blank"} in errors_on(%Clip{}, %{})
    assert {:user_id, "can't be blank"} in errors_on(%Clip{}, %{})
  end
end
