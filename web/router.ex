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
    put "/users/:user_id/devices", DeviceController, :create
    put "/users/:user_id/follow", FollowController, :create
    delete "/users/:user_id/follow", FollowController, :delete

    resources "/clips", ClipController, only: [:delete]
    put "/clips/:clip_id/like", LikeController, :create
    delete "/clips/:clip_id/like", LikeController, :delete
    put "/clips/:clip_id/flag", FlagController, :create
    get "/clips/stream", ClipController, :index
  end
end
