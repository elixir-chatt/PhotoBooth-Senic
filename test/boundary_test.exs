defmodule BoundaryTest do
  use ExUnit.Case
  alias Pex.Boundary.Camera, as: Camera
  alias Pex.Test.Support.Utilities, as: Utilities

  test "take picture" do
    camera =
      %Camera{}
      |> Camera.take_picture

    assert camera.picture == "photo1.jpg"
  end

  test "take picture2" do
    %Camera{}
    |> Camera.take_picture
    |> Utilities.assert_key(:picture, "photo1.jpg")
  end

end
