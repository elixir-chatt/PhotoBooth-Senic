defmodule CoreTest do
  use ExUnit.Case

  test "test defaults" do
    photobooth = Pex.Core.PhotoBooth.new
    assert photobooth.troll == false
  end
end
