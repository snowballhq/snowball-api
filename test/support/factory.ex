defmodule Snowball.Factory do
  use ExMachina.Ecto, repo: Snowball.Repo

  def user_factory do
    %Snowball.User{
      username: "username",
      email: "example@example.com",
      password_digest: "password_digest",
      auth_token: "auth_token"
    }
  end

  def user_before_registration_factory do
    %Snowball.User{
      username: "username",
      email: "example@example.com",
      password: "test"
    }
  end
end
