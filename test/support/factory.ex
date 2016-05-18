defmodule Snowball.Factory do
  use ExMachina.Ecto, repo: Snowball.Repo

  def user_factory do
    %Snowball.User{
      username: "username",
      email: "example@example.com"
    }
  end
end
