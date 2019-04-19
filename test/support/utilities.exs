defmodule Pex.Test.Support.Utilities do
  use ExUnit.Case
  def assert_key(item, key, actual) do
    expected = Map.get(item, key)

    assert expected == actual
    item
  end
end
