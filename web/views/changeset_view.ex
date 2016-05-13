defmodule Snowball.ChangesetView do
  use Snowball.Web, :view

  def render("error.json", %{changeset: changeset}) do
    # TODO: Make this human-readable
    %{errors: Enum.into(changeset.errors, %{})}
  end
end
