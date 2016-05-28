defmodule Snowball.SpecControllerCase do
  defmacro __using__(_opts) do
    quote do
      use Snowball.SpecCase
      use Phoenix.ConnTest

      @endpoint Snowball.Endpoint

      import Snowball.SpecControllerCase
      import Snowball.Router.Helpers

      def authenticate(conn, auth_token) do
        header_content = "Basic " <> Base.encode64("#{auth_token}:")
        conn |> put_req_header("authorization", header_content)
      end

      def clip_response(clip) do
        %{"id" => clip.id}
      end

      def error_not_found_response do
        %{"message" => "Not found"}
      end

      def error_unauthorized_response do
        %{"message" => "Unauthorized"}
      end
    end
  end
end
