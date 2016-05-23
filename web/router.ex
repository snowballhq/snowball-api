defmodule Snowball.Router do
  use Snowball.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Snowball do
    pipe_through :api

    get "/", HomeController, :index
    resources "/users", UserController, except: [:new, :edit] do
      post "/follow", FollowController, :create
      delete "/follow", FollowController, :delete
    end
    post "/users/sign-up", RegistrationController, :create
    post "/users/sign-in", SessionController, :create
  end
end
