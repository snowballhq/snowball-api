defmodule Snowball do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    tree = [supervisor(Snowball.Repo, [])]
    opts = [strategy: :one_for_one, name: Snowball.Supervisor]
    Supervisor.start_link(tree, opts)
  end
end
