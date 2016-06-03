defmodule Snowball.ModelCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Snowball.TestCase

      import Snowball.ModelCase
    end
  end

  setup tags do
    Snowball.TestCase.setup(tags)
    :ok
  end
end
