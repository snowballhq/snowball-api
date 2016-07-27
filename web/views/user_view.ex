defmodule Snowball.UserView do
  use Snowball.Web, :view

  def render("index.json", assigns) do
    render_many(assigns.users, Snowball.UserView, "user.json", assigns)
  end

  def render("show.json", assigns) do
    render_one(assigns.user, Snowball.UserView, "user.json", assigns)
  end

  def render("show-auth.json", assigns) do
    user_json(assigns)
    |> Map.merge(%{
      auth_token: assigns.user.auth_token
    })
  end

  def render("user.json", assigns) do
    user_json(assigns)
  end

  defp user_json(assigns) do
    user = assigns.user
    current_user = assigns.current_user
    json = %{
      id: user.id,
      username: user.username,
      avatar_url: Snowball.UserAvatar.url({user.avatar, user}),
      following: Snowball.User.following?(current_user, user)
    }
    json =
      if current_user.id == user.id do
        json = Map.merge(json, %{
          phone_number: user.phone_number,
          email: user.email
        })
      else
        json
      end
    json
  end
end
