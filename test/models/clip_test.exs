defmodule Snowball.ClipTest do
  use Snowball.ModelCase

  alias Snowball.Clip

  test "changeset validations" do
    assert {:video_file_name, "can't be blank"} in errors_on(%Clip{}, %{video_file_name: nil})
    assert {:video_content_type, "can't be blank"} in errors_on(%Clip{}, %{video_content_type: nil})
    assert {:thumbnail_file_name, "can't be blank"} in errors_on(%Clip{}, %{thumbnail_file_name: nil})
    assert {:thumbnail_content_type, "can't be blank"} in errors_on(%Clip{}, %{thumbnail_content_type: nil})
  end
end
