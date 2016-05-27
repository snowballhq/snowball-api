defmodule Snowball.UserTest do
  use Snowball.ModelCase

  alias Snowball.User

  test "changeset/2" do
    assert "can't be blank" in errors_on(%User{}, :email)
    assert "can't be blank" in errors_on(%User{}, :username)
    assert "has invalid format" in errors_on(%User{}, :email, "")
    assert "has invalid format" in errors_on(%User{}, :email, "example@example")
    assert "has invalid format" in errors_on(%User{}, :username, "")
    assert "should be at least 3 characters" in errors_on(%User{}, :username, "")
    assert "should be at most 15 characters"in errors_on(%User{}, :username, "aaaaaaaaaaaaaaaa")
    assert "should be at least 5 characters" in errors_on(%User{}, :password, "")
    assert "is invalid" in errors_on(%User{}, :phone_number, "123")
    assert "is invalid" in errors_on(%User{}, :phone_number, "415123456")
    refute "is invalid" in errors_on(%User{}, :phone_number, "2025550197")
    refute "is invalid" in errors_on(%User{}, :phone_number, "+353872942731") # Ireland
    refute "is invalid" in errors_on(%User{}, :phone_number, "+491622797078") # Germany
    # TODO: Add uniqueness validations
  end

  test "registration_changeset/2" do
    # TODO: Can I also check that this runs changeset/2?
    assert "can't be blank" in errors_on(%User{}, &User.registration_changeset/2, :password, nil)
  end

  test "follow_for/2" do
    follow = insert(:follow)
    assert follow.id == User.follow_for(follow.follower, follow.following).id
  end

  test "following?/2" do
    follow = insert(:follow)
    assert User.following?(follow.follower, follow.following)
    refute User.following?(follow.following, follow.follower)
  end

  test "follow/2" do
    follower = insert(:user)
    followed = insert(:user)
    refute User.following?(follower, followed)
    User.follow(follower, followed)
    assert User.following?(follower, followed)
  end

  test "unfollow/2" do
    follow = insert(:follow)
    assert User.following?(follow.follower, follow.following)
    User.unfollow(follow.follower, follow.following)
    refute User.following?(follow.follower, follow.following)
  end
end
