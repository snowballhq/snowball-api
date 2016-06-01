defmodule Snowball do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    children = [
      supervisor(Snowball.Repo, []),
      Plug.Adapters.Cowboy.child_spec(:http, Snowball.Router, [], [port: 4000])
    ]
    opts = [strategy: :one_for_one, name: Snowball.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
