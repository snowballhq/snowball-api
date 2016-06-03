defmodule Snowball.UserView do
  use Snowball.Web, :view

  def render("index.json", assigns) do
    render_many(assigns.users, Snowball.UserView, "user.json", assigns)
  end

  def render("show.json", assigns) do
    render_one(assigns.user, Snowball.UserView, "user.json", assigns)
  end

  def render("show-auth.json", %{user: user}) do
    render_one(user, Snowball.UserView, "user-auth.json")
  end

  def render("user.json", assigns) do
    user = assigns.user
    json = %{
      id: user.id,
      username: user.username,
      avatar_url: nil,
      email: user.email
    }
    if current_user = assigns[:current_user] do
      json = Map.merge(json, %{
        following: Snowball.User.following?(current_user, user)
      })
    end
    json
  end

  def render("user-auth.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      email: user.email,
      avatar_url: nil,
      auth_token: user.auth_token}
  end
end
