defmodule Snowball.UserTest do
  use Snowball.ModelCase, async: true

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

  test "follow_for/2 when the follow exists returns the follow" do
    follow = insert(:follow)
    assert User.follow_for(follow.follower, follow.following).id == follow.id
  end

  test "follow_for/2 when the follow does not exist returns nil" do
    follower = insert(:user)
    followed = insert(:user)
    refute User.follow_for(follower, followed)
  end

  test "following?/2 when the follow exists returns true" do
    follow = insert(:follow)
    assert User.following?(follow.follower, follow.following)
  end

  test "following?/2 when the follow does not exist returns false" do
    follower = insert(:user)
    followed = insert(:user)
    refute User.following?(follower, followed)
  end

  test "follow/2 when not following follows the user and returns true" do
    follower = insert(:user)
    followed = insert(:user)
    refute User.following?(follower, followed)
    assert User.follow(follower, followed)
    assert User.following?(follower, followed)
  end

  test "follow/2 when following does not create a duplicate follow and returns false" do
    follow = insert(:follow)
    assert User.following?(follow.follower, follow.following)
    refute User.follow(follow.follower, follow.following)
    assert Repo.one(from f in Follow, select: count(f.id)) == 1
  end

  test "follow/2 when trying to follow self does not create a follow and returns false" do
    user = insert(:user)
    refute User.follow(user, user)
    assert Repo.one(from f in Follow, select: count(f.id)) == 0
  end

  test "unfollow/2 when following unfollows the user and returns true" do
    follow = insert(:follow)
    assert User.following?(follow.follower, follow.following)
    assert User.unfollow(follow.follower, follow.following)
    refute User.following?(follow.follower, follow.following)
  end

  test "unfollow/2 when not following returns false" do
    follower = insert(:user)
    followed = insert(:user)
    refute User.following?(follower, followed)
    refute User.unfollow(follower, followed)
    refute User.following?(follower, followed)
  end
end
