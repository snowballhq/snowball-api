defmodule Snowball.Router do
  use Snowball.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Snowball do
    pipe_through :api

    get "/", HomeController, :index

    resources "/users", UserController, only: [:show, :update]
    post "/users/sign-up", RegistrationController, :create
    post "/users/sign-in", SessionController, :create
    put "/users/:id/follow", FollowController, :create
    delete "/users/:id/follow", FollowController, :delete

    resources "/clips", ClipController, only: [:delete]
    put "/clips/:id/like", LikeController, :create
    delete "/clips/:id/like", LikeController, :delete
    get "/clips/stream", ClipController, :index
  end
end
