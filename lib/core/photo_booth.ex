defmodule Pex.Core.PhotoBooth do
  defstruct [:mode, :photo, :troll, :seconds_to_countdown, :taken, :photos, :chosen]
  @max_seconds_to_countdown 3
  @pictures_to_take 5

  def new do
    %__MODULE__{
      # :ready, :countdown, :shooting, :choosing, :transmitting
      mode: :ready,
      photo: <<>>,
      troll: false,
      seconds_to_countdown: @max_seconds_to_countdown,
      taken: 0,
      photos: [],
      chosen: []
    }
  end

  # ready mode
  def display(booth, photo) do
    %{booth | photo: photo}
  end

  def start(%{mode: :ready} = booth) do
    %{booth | seconds_to_countdown: @max_seconds_to_countdown, taken: 0, photos: [], chosen: []}
    |> change_mode(:countdown)
  end

  def countdown(%{seconds_to_countdown: 0} = booth) do
    booth
    |> change_mode(:shooting)
    |> Map.put(:seconds_to_countdown, @max_seconds_to_countdown)
  end

  def countdown(booth) do
    %{booth | seconds_to_countdown: booth.seconds_to_countdown - 1}
  end

  def add_taken_photo(booth, photo) do
    booth
    |> Map.put(:photos, [photo | booth.photos])
    |> Map.put(:taken, booth.taken + 1)
    |> advance_from_shooting
  end

  def advance_from_shooting(%{taken: @pictures_to_take} = booth) do
    booth
    |> Map.put(:taken, 0)
    |> change_mode(:choosing)
  end

  def advance_from_shooting(booth) do
    booth
    |> change_mode(:countdown)
  end

  def choose(%{photos: [pic | pics], chosen: chosen} = booth, :accept) do
    %{booth | photos: pics, chosen: [pic | chosen], mode: next_choosing_mode(pics)}
  end
  def choose(%{photos: [_pic | pics], chosen: chosen} = booth, :reject) do
    %{booth | photos: pics, chosen: chosen, mode: next_choosing_mode(pics)}
  end
  
  def next_choosing_mode([]), do: :transmitting
  def next_choosing_mode(_pictures), do: :choosing

  def reject(%{photos: [_pic | pics]} = booth), do: %{booth | photos: pics}

  def change_mode(booth, mode) do
    %{booth | mode: mode}
  end

  def transmit(%{photos: []} = booth), do: change_mode(booth, :transmitting)

  def finish(%{mode: :transmitting} = booth) do
    change_mode(booth, :ready)
  end

  def finish(booth), do: booth
end
