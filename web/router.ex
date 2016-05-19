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
  end
end
