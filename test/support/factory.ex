defmodule Snowball.Factory do
  use ExMachina.Ecto, repo: Snowball.Repo

  def user_factory do
    %Snowball.User{
      username: Faker.Internet.user_name(),
      email: Faker.Internet.email(),
      password_digest: to_string(Faker.Lorem.characters()),
      auth_token: to_string(Faker.Lorem.characters())
    }
  end

  def user_before_registration_factory do
    %Snowball.User{
      username: Faker.Internet.user_name(),
      email: Faker.Internet.email(),
      password: to_string(Faker.Lorem.characters())
    }
  end
end
