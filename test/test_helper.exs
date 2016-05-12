ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Snowball.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Snowball.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Snowball.Repo)

