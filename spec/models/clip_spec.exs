defmodule Snowball.ClipSpec do
  use Snowball.SpecModelCase

  describe "changeset/2" do
    it do: expect errors_on(%Clip{}, :video_file_name) |> to(have "can't be blank")
    it do: expect errors_on(%Clip{}, :video_content_type) |> to(have "can't be blank")
    it do: expect errors_on(%Clip{}, :thumbnail_file_name) |> to(have "can't be blank")
    it do: expect errors_on(%Clip{}, :thumbnail_content_type) |> to(have "can't be blank")
    it do: expect errors_on(%Clip{}, :user_id) |> to(have "can't be blank")
  end
end
