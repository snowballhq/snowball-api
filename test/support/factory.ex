defmodule Snowball.Factory do
  use ExMachina.Ecto, repo: Snowball.Repo

  def clip_factory do
    %Snowball.Clip{
      user: build(:user),
      video_file_name: %{file_name: "test/fixtures/video.mp4", updated_at: Ecto.DateTime.utc},
      video_content_type: "video_content_type",
      thumbnail_file_name: "thumbnail_file_name",
      thumbnail_content_type: "thumbnail_content_type"
    }
  end

  # def new_clip_factory do
  #   %Snowball.Clip{
  #     user: build(:user),
  #     video_file_name: %Plug.Upload{path: "test/fixtures/video.mp4", filename: "video.mp4"}
  #   }
  # end

  def installation_factory do
    %Snowball.Installation{
      user: build(:user),
      arn: to_string(Faker.Lorem.characters)
    }
  end

  def follow_factory do
    %Snowball.Follow{
      follower: build(:user),
      followed: build(:user)
    }
  end

  def like_factory do
    %Snowball.Like {
      user: build(:user),
      clip: build(:clip)
    }
  end

  def user_factory do
    %Snowball.User{
      username: Faker.Name.first_name,
      email: Faker.Internet.email,
      password_digest: to_string(Faker.Lorem.characters),
      auth_token: to_string(Faker.Lorem.characters)
    }
  end

  def user_before_registration_factory do
    %Snowball.User{
      username: Faker.Name.first_name,
      email: Faker.Internet.email,
      password: to_string(Faker.Lorem.characters)
    }
  end
end
