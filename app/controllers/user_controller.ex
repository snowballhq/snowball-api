defmodule Snowball.UserController do
  use Snowball.Controller

  alias Snowball.{ChangesetErrorsHelper, User}

  def show(conn, id) do
    if user = Repo.get(User, id) do
      render(conn, json: User.json(user))
    else
      head(conn, 404)
    end
  end

  def update(conn, id) do
    if user = Repo.get(User, id) do
      changeset = User.changeset(user, conn.params)
      case Repo.update(changeset) do
        {:ok, user} ->
          render(conn, json: User.json(user))
        {:error, changeset} ->
          render(conn, json: ChangesetErrorsHelper.json(changeset), status: 422)
      end
    else
      head(conn, 404)
    end
  end
end
