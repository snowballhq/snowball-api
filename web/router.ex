defmodule Snowball.Router do
  use Snowball.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  get "/", Snowball.HomeController, :index

  scope "/v1", Snowball do
    pipe_through :api

    get "/", HomeController, :index

    patch "/users/me", UserController, :update
    post "/users/sign-up", RegistrationController, :create
    post "/users/sign-in", SessionController, :create
    post "/users/search", UserController, :search, as: :user_search
    get "/users/recommended", UserController, :recommended, as: :user_recommended

    resources "/users", UserController, only: [:show] do
      get "/clips/stream", ClipController, :index

      get "/following", FollowController, :following, as: :following
      get "/followers", FollowController, :followers, as: :followers
      put "/follow", FollowController, :create
      delete "/follow", FollowController, :delete
    end

    get "/clips/stream", ClipController, :index

    resources "/clips", ClipController, only: [:create, :delete] do
      put "/like", LikeController, :create
      delete "/like", LikeController, :delete
      put "/flag", FlagController, :create
    end

    put "/installations", InstallationController, :create
  end
end
