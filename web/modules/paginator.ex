defmodule Snowball.Paginator do
  import Ecto.Query

  def page(query, page, per_page \\ 25) do
    page =
      if page do
        String.to_integer(page)
      else
        1
      end
    offset = per_page * page - per_page
    query |> limit(^per_page) |> offset(^offset)
  end
end
