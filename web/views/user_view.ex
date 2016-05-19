defmodule Snowball.UserView do
  use Snowball.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Snowball.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Snowball.UserView, "user.json")}
  end

  def render("show-auth.json", %{user: user}) do
    %{data: render_one(user, Snowball.UserView, "user-auth.json")}
  end

  def render("error-auth-email.json", %{}) do
    %{error: %{message: "Invalid email"}}
  end

  def render("error-auth-password.json", %{}) do
    %{error: %{message: "Invalid password"}}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      email: user.email}
  end

  def render("user-auth.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      email: user.email,
      auth_token: user.auth_token}
  end
end
