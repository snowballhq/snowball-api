defmodule Snowball.ErrorView do
  use Snowball.Web, :view

  def render("400.json", _assigns) do
    %{message: "Bad request"}
  end

  def render("401.json", _assigns) do
    %{message: "Unauthorized"}
  end

  def render("404.json", _assigns) do
    %{message: "Not found"}
  end

  def render("500.json", _assigns) do
    %{message: "Server internal error"}
  end

  def render("error.json", assigns) do
    cond do
      assigns[:message] ->
        %{message: assigns.message}
      assigns[:changeset] ->
        render_changeset_errors(assigns[:changeset])
      true ->
        render "500.json", assigns
    end
  end

  defp render_changeset_errors(changeset) do
    errors = Snowball.ChangesetErrorFormatter.reformat_errors(changeset.errors)
    errors = errors
    |> Map.keys
    |> Enum.map(fn(key) ->
      %{field: key, message: List.first(errors[key])}
    end)
    %{
      message: "Validation failed",
      errors: errors
    }
  end

  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end
end
