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
    assert User.follow_for(follow.follower, follow.followed).id == follow.id
  end

  test "follow_for/2 when the follow does not exist returns nil" do
    follower = insert(:user)
    followed = insert(:user)
    refute User.follow_for(follower, followed)
  end

  test "following?/2 when the follow exists returns true" do
    follow = insert(:follow)
    assert User.following?(follow.follower, follow.followed)
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

  test "follow/2 when following does not create a duplicate follow and returns true" do
    follow = insert(:follow)
    assert User.following?(follow.follower, follow.followed)
    assert User.follow(follow.follower, follow.followed)
    assert Repo.one(from f in Follow, select: count(f.id)) == 1
  end

  test "follow/2 when trying to follow self does not create a follow and returns false" do
    user = insert(:user)
    refute User.follow(user, user)
    assert Repo.one(from f in Follow, select: count(f.id)) == 0
  end

  test "unfollow/2 when following unfollows the user and returns true" do
    follow = insert(:follow)
    assert User.following?(follow.follower, follow.followed)
    assert User.unfollow(follow.follower, follow.followed)
    refute User.following?(follow.follower, follow.followed)
  end

  test "unfollow/2 when not following returns true" do
    follower = insert(:user)
    followed = insert(:user)
    refute User.following?(follower, followed)
    assert User.unfollow(follower, followed)
    refute User.following?(follower, followed)
  end

  test "like_for/2 when the like exists returns the like" do
    like = insert(:like)
    assert User.like_for(like.user, like.clip).id == like.id
  end

  test "like_for/2 when the like does not exist returns nil" do
    user = insert(:user)
    clip = insert(:clip)
    refute User.like_for(user, clip)
  end

  test "likes?/2 when the like exists returns true" do
    like = insert(:like)
    assert User.likes?(like.user, like.clip)
  end

  test "likes?/2 when the like does not exist returns false" do
    user = insert(:user)
    clip = insert(:clip)
    refute User.likes?(user, clip)
  end

  test "like/2 when not liked likes the clip and returns true" do
    user = insert(:user)
    clip = insert(:clip)
    refute User.likes?(user, clip)
    assert User.like(user, clip)
    assert User.likes?(user, clip)
  end

  test "like/2 when liked does not create a duplicate like and returns true" do
    like = insert(:like)
    assert User.likes?(like.user, like.clip)
    assert User.like(like.user, like.clip)
    assert Repo.one(from l in Like, select: count(l.id)) == 1
  end

  test "unlike/2 when liked unlikes the clip and returns true" do
    like = insert(:like)
    assert User.likes?(like.user, like.clip)
    assert User.unlike(like.user, like.clip)
    refute User.likes?(like.user, like.clip)
  end

  test "unlike/2 when not liked returns true" do
    user = insert(:user)
    clip = insert(:clip)
    refute User.likes?(user, clip)
    assert User.unlike(user, clip)
    refute User.likes?(user, clip)
  end

  test "flag/2 creates a flag and returns true" do
    clip = insert(:clip)
    assert User.flag(clip.user, clip)
  end

  test "flag/2 when a clip does not exist does not create a flag and returns false" do
    user = insert(:user)
    clip = build(:clip, user: user)
    refute User.flag(user, clip)
  end
end
