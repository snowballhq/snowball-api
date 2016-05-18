{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Snowball.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Snowball.Repo --quiet)
Ecto.Adapters.SQL.Sandbox.mode(Snowball.Repo, :manual)
