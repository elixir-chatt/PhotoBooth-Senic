defmodule Pex.Core.PhotoBooth do
  defstruct [:mode, :photo, :troll, :count_down, :taken, :photos, :chosen]
  
  def new do
    %{
      mode: :ready,
      photo: <<>>,
      troll: false,
      count_down: 3,
      taken: 0,
      photos: [],
      chosen: [],
    }
  end
end