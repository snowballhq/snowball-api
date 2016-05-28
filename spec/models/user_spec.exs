defmodule Snowball.UserSpec do
  use Snowball.SpecModelCase

  describe "changeset/2" do
    it do: expect errors_on(%User{}, :email) |> to(have "can't be blank")
    it do: expect errors_on(%User{}, :username) |> to(have "can't be blank")
    it do: expect errors_on(%User{}, :email, "") |> to(have "has invalid format")
    it do: expect errors_on(%User{}, :email, "example@example") |> to(have "has invalid format")
    it do: expect errors_on(%User{}, :username, "") |> to(have "has invalid format")
    it do: expect errors_on(%User{}, :username, "") |> to(have "should be at least 3 characters")
    it do: expect errors_on(%User{}, :username, "aaaaaaaaaaaaaaaa") |> to(have "should be at most 15 characters")
    it do: expect errors_on(%User{}, :password, "") |> to(have "should be at least 5 characters")
    it do: expect errors_on(%User{}, :phone_number, "123") |> to(have "is invalid")
    it do: expect errors_on(%User{}, :phone_number, "415123456") |> to(have "is invalid")
    it do: expect errors_on(%User{}, :phone_number, "2025550197") |> to_not(have "is invalid")
    it do: expect errors_on(%User{}, :phone_number, "+353872942731") |> to_not(have "is invalid") # Ireland
    it do: expect errors_on(%User{}, :phone_number, "+491622797078") |> to_not(have "is invalid") # Germany
    # TODO: Add uniqueness validations
  end

  describe "registration_changeset/2" do
    # TODO: Can I also check that this runs changeset/2?
    it do: expect errors_on(%User{}, &User.registration_changeset/2, :password, nil) |> to(have "can't be blank")
  end

  describe "follow_for/2" do
    it "returns the follow if it exists" do
      follow = insert(:follow)
      expect User.follow_for(follow.follower, follow.following).id |> to(eq follow.id)
    end
    it "returns nil if the follow does not exist" do
      follower = insert(:user)
      followed = insert(:user)
      expect User.follow_for(follower, followed) |> to(be_nil)
    end
  end

  describe "following?/2" do
    it "returns true if the follow exists" do
      follow = insert(:follow)
      expect User.following?(follow.follower, follow.following) |> to(be_true)
    end
    it "returns false if the follow does not exist" do
      follower = insert(:user)
      followed = insert(:user)
      expect User.following?(follower, followed) |> to(be_false)
    end
  end

  describe "follow/2" do
    it "follows the user" do
      follower = insert(:user)
      followed = insert(:user)
      expect User.following?(follower, followed) |> to(be_false)
      expect User.follow(follower, followed) |> to(be_true)
      expect User.following?(follower, followed) |> to(be_true)
    end

    it "does not create a duplicate follow if already following" do
      follow = insert(:follow)
      expect User.follow(follow.follower, follow.following) |> to(be_false)
    end

    it "does not follow the user if it is the current user" do
      user = insert(:user)
      expect User.follow(user, user) |> to(be_false)
    end
  end

  describe "unfollow/2" do
    it "unfollows the user" do
      follow = insert(:follow)
      expect User.following?(follow.follower, follow.following) |> to(be_true)
      expect User.unfollow(follow.follower, follow.following) |> to(be_true)
      expect User.following?(follow.follower, follow.following) |> to(be_false)
    end

    it "returns false if not following" do
      follower = insert(:user)
      followed = insert(:user)
      expect User.following?(follower, followed) |> to(be_false)
      expect User.unfollow(follower, followed) |> to(be_false)
      expect User.following?(follower, followed) |> to(be_false)
    end
  end
end
