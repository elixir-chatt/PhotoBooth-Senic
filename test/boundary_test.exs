defmodule BoundaryTest do
  use ExUnit.Case
  alias Pex.Boundary.Camera
  alias Pex.Test.Support.Utilities

  test "take picture2" do
    %Camera{}
    |> Camera.take_picture
    |> Utilities.assert_key(:picture, "photo1.jpg")
  end

end
