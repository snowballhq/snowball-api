defmodule Snowball.Router do
  use Snowball.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Snowball do
    pipe_through :api

    get "/", HomeController, :index

    resources "/users", UserController, except: [:new, :edit]
    post "/users/sign-up", RegistrationController, :create
    post "/users/sign-in", SessionController, :create
    put "/users/:id/follow", FollowController, :create
    delete "/users/:id/follow", FollowController, :delete

    resources "/clips", ClipController, only: [:delete]
    get "/clips/stream", ClipController, :index
  end
end
