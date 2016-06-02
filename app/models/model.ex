defmodule Snowball.Model do
  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
      import Ecto.Query

      @primary_key {:id, :binary_id, read_after_writes: true}
      @foreign_key_type :binary_id
      @timestamps_opts [inserted_at: :created_at]

      def to_json(structs) when is_list(structs) do
        structs |> Enum.map(fn(struct) ->
          struct |> json
        end) |> Poison.encode!
      end

      def to_json(struct) do
        struct |> json |> Poison.encode!
      end
    end
  end
end
