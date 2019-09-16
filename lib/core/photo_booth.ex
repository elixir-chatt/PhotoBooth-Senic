defmodule Pex.Core.PhotoBooth do
  defstruct [:mode, :photo, :troll, :countdown_list, :taken, :photos, :chosen]
  @max_countdown_list 3
  @pictures_to_take 5

  def new(troll) do
    %__MODULE__{
      # :ready, :countdown, :shooting, :choosing, :transmitting
      mode: :ready,
      photo: <<>>,
      troll: troll,
      countdown_list: make_countdown(@max_countdown_list, troll),
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
    %{
      booth | 
        countdown_list: make_countdown(@max_countdown_list, booth.troll), 
        taken: 0, 
        photos: [], 
        chosen: []
    }
    |> change_mode(:countdown)
  end

  def countdown(%{countdown_list: []} = booth) do
    booth
    |> change_mode(:shooting)
    |> Map.put(:countdown_list, make_countdown(@max_countdown_list, booth.troll))
  end

  def countdown(%{countdown_list: [_head|tail]}=booth) do
    %{booth | countdown_list: tail}
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
  
  def make_nice_countdown_tuple(x) do 
    {x,1000}
  end 

  def make_troll_countdown_tuple(_x) do 
    {:random.uniform(10) - 1, :random.uniform(600)}
  end 
  
  def make_countdown(max, false=_troll) do
    (max..1)
    |> Enum.map(&make_nice_countdown_tuple/1)
  end

  def make_countdown(max, true=_troll) do
    number = :random.uniform(max)
    
    ((number * number)..1)
    |> Enum.to_list
    |> tl
    |> Enum.map(&make_troll_countdown_tuple/1)
  end
end


