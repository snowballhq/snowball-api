defmodule Snowball.FollowSpec do
  use Snowball.SpecModelCase

  describe "changeset/2" do
    it do: expect errors_on(%Follow{}, :follower_id) |> to(have "can't be blank")
    it do: expect errors_on(%Follow{}, :following_id) |> to(have "can't be blank")
  end
end
