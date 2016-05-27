defmodule Snowball.ClipTest do
  use Snowball.ModelCase

  alias Snowball.Clip

  test "changeset/2" do
    assert "can't be blank" in errors_on(%Clip{}, :video_file_name)
    assert "can't be blank" in errors_on(%Clip{}, :video_content_type)
    assert "can't be blank" in errors_on(%Clip{}, :thumbnail_file_name)
    assert "can't be blank" in errors_on(%Clip{}, :thumbnail_content_type)
    assert "can't be blank" in errors_on(%Clip{}, :user_id)
  end
end
