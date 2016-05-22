defmodule Snowball.AuthenticateView do
  use Snowball.Web, :view

# TODO: Should this even exist?
  def render("authenticate.json", _assigns) do
    %{errors: %{detail: "Authentication required"}}
  end
end
