defmodule Snowball.Paginator do
  import Ecto.Query

  def page(query, page, per_page \\ 25) do
    if page do
      page = String.to_integer(page)
    else
      page = 1
    end
    offset = per_page * page - per_page
    query |> limit(^per_page) |> offset(^offset)
  end
end
