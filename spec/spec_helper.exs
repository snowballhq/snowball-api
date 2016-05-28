{:ok, _} = Application.ensure_all_started(:ex_machina)
{:ok, _} = Application.ensure_all_started(:faker)

Ecto.Adapters.SQL.Sandbox.mode(Snowball.Repo, :manual)

ESpec.configure fn(config) ->
  config.before fn ->

    # TODO: Figure out where these Ecto lines should go. They need to run
    # before every spec
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Snowball.Repo)
    # unless tags[:async] do
    #   Ecto.Adapters.SQL.Sandbox.mode(Snowball.Repo, {:shared, self()})
    # end

    {:shared, hello: :world}
  end

  config.finally fn(_shared) ->
    :ok
  end
end
