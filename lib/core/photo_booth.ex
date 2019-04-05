defmodule Pex.Core.PhotoBooth do
  defstruct [:mode, :photo, :troll, :count_down, :taken, :photos, :chosen]
  @seconds_to_countdown 3
  @pictures_to_take 5
  
  def new do
    %{
      mode: :ready, #:ready, :countdown, :shooting, :choose, :transmit
      photo: <<>>,
      troll: false,
      count_down: @seconds_to_countdown,
      taken: 0,
      photos: [],
      chosen: [],
    }
  end
  
  #ready mode
  def display(booth, photo) do
    %{booth | photo: photo}
  end
  
  def change_mode(booth, mode) do
    %{booth | mode: mode }
  end
  
  def countdown(%{count_down: 0} = booth) do
    booth
    |> change_mode(:shooting)
    |> Map.put(:count_down, @seconds_to_countdown)
  end
  
  def countdown(booth) do
    %{booth | count_down: booth.count_down-1 }  
  end
  
  def take_picture(booth, photo) do
    booth
    |> Map.put(:photos, [photo | booth.photos])
    |> Map.put(:taken, booth.taken + 1)
    |> advance
  end
  
  def advance(%{taken: @pictures_to_take}=booth) do
    booth
    |> Map.put(:taken, 0)
    |> change_mode(:choose)
  end

  def advance(booth) do
    booth
    |> change_mode(:countdown)
  end
  
  
  
  
end