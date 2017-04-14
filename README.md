# Snowball

### System Dependencies

* [Elixir](http://elixir-lang.org)
* [Phoenix](http://www.phoenixframework.org)
* [PostgreSQL](http://www.postgresql.org)
* [Heroku Toolbelt](http://toolbelt.heroku.com)

### Configuration

TODO: Add environment variable config

### Database Setup

1. `postgres -D /usr/local/var/postgres`
1. `mix ecto.create && mix ecto.migrate`

### Local Environment Setup

1. `mix deps.get`
1. `mix phoenix.server`

### Test Suite

1. `mix test`

### Linting

1. `mix credo`

### Deployment Instructions

1. `heroku git:remote -a snowball-api`
1. `git push heroku`

### Remote Console

#### Updating a password
1. `heroku run iex -S mix`
```elixir
iex > import Ecto.Query
iex > user = Snowball.User |> where([u], u.email == "jamescmartinez@gmail.com") |> Snowball.Repo.one
iex > params = %{password: "newpassword"}
iex > changeset = Snowball.User.changeset(user, params)
iex > Snowball.Repo.update(changeset)
```
