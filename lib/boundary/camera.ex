defmodule Pex.Boundary.Camera do

  defstruct [:picture, photos_taken: 0]

  def take_picture(camera) do
    camera = Map.put(camera, :photos_taken, camera.photos_taken + 1)
    %{
      camera
      | picture: "photo#{camera.photos_taken}.jpg"
    }
  end
end
