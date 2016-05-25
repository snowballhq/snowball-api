defmodule Snowball.Factory do
  use ExMachina.Ecto, repo: Snowball.Repo

  def clip_factory do
    %Snowball.Clip{
      user: build(:user),
      video_file_name: "video_file_name",
      video_content_type: "video_content_type",
      thumbnail_file_name: "thumbnail_file_name",
      thumbnail_content_type: "thumbnail_content_type"
    }
  end

  def follow_factory do
    %Snowball.Follow{
      follower: build(:user),
      following: build(:user)
    }
  end

  def user_factory do
    %Snowball.User{
      username: Faker.Name.first_name(),
      email: Faker.Internet.email(),
      password_digest: to_string(Faker.Lorem.characters()),
      auth_token: to_string(Faker.Lorem.characters())
    }
  end

  def user_before_registration_factory do
    %Snowball.User{
      username: Faker.Name.first_name(),
      email: Faker.Internet.email(),
      password: to_string(Faker.Lorem.characters())
    }
  end
end
