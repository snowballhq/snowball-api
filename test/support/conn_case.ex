defmodule Snowball.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Snowball.TestCase
      use Plug.Test

      import Snowball.ConnCase

      @endpoint Snowball.Endpoint
    end
  end

  setup tags do
    Snowball.TestCase.setup(tags)
    :ok
  end
end
