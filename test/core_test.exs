defmodule CoreTest do
  use ExUnit.Case
  alias Pex.Core.PhotoBooth

  def default(), do: PhotoBooth.new
  
  def photo(), do: <<>>

  def full() do
    PhotoBooth.new
    |> PhotoBooth.start
    |> PhotoBooth.add_taken_photo(photo())
    |> PhotoBooth.add_taken_photo(photo())
    |> PhotoBooth.add_taken_photo(photo())
    |> PhotoBooth.add_taken_photo(photo())
    |> PhotoBooth.add_taken_photo(photo())
  end

  test "test defaults" do
    default()
    |> assert_key(:troll, false)
    |> assert_key(:seconds_to_countdown, 3)
  end

  test "test the changing of mode" do
    default()
    |> PhotoBooth.change_mode(:countdown)
    |> assert_key(:mode, :countdown)
  end

  test "test countdown" do
    default()
    |> PhotoBooth.countdown()
    |> assert_key(:seconds_to_countdown, 2)
    |> PhotoBooth.countdown()
    |> assert_key(:seconds_to_countdown, 1)
    |> PhotoBooth.countdown()
    |> assert_key(:seconds_to_countdown, 0)
  end

  test "test countdown full" do
    default()
    |> PhotoBooth.countdown()
    |> PhotoBooth.countdown()
    |> PhotoBooth.countdown()
    |> assert_key(:seconds_to_countdown, 0)
    |> PhotoBooth.countdown()
    |> assert_key(:seconds_to_countdown, 3)
    |> assert_key(:mode, :shooting)
  end

  test "test take pictures" do
    default()
    |> PhotoBooth.add_taken_photo(photo())
    |> PhotoBooth.add_taken_photo(photo())
    |> PhotoBooth.add_taken_photo(photo())
    |> assert_key(:photos, [photo(), photo(), photo()])
    |> assert_key(:taken, 3)
  end

  test "test advancing the mode back to countdown" do
    default()
    |> PhotoBooth.change_mode(:shooting)
    |> PhotoBooth.advance_from_shooting()
    |> assert_key(:mode, :countdown)
  end

  test "test advancing the mode to the selection process" do
    full()
    |> assert_key(:mode, :choosing)
  end

  test "test start choosing mode" do
    full()
    |> PhotoBooth.choose([1,2,3])
    |> assert_key(:mode, :transmitting)
  end

  test "test proper finish" do
    full()
    |> PhotoBooth.choose([1,2,3])
    |> PhotoBooth.finish
    |> PhotoBooth.start
    |> assert_key(:seconds_to_countdown, 3)
    |> assert_key(:taken, 0)
    |> assert_key(:photos, [])
    |> assert_key(:chosen, [])
  end


  defp assert_key(booth, key, actual) do
    expected = Map.get(booth, key)

    assert expected == actual
    booth
  end

end
