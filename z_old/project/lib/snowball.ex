defmodule Snowball do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    children = [
      supervisor(Snowball.Endpoint, []),
      supervisor(Snowball.Repo, []),
    ]
    opts = [strategy: :one_for_one, name: Snowball.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Snowball.Endpoint.config_change(changed, removed)
    :ok
  end
end
