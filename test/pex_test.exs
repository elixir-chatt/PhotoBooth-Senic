defmodule PexTest do
  use ExUnit.Case
  doctest Pex

  test "greets the world" do
    assert Pex.hello() == :world
  end
end
