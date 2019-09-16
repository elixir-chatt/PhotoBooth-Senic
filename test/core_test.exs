defmodule CoreTest do
  use ExUnit.Case
  alias Pex.Core.PhotoBooth
  
  @default_countdown [{3, 1000}, {2, 1000}, {1, 1000}]

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

  def almost_empty() do
    PhotoBooth.new
    |> PhotoBooth.start
    |> PhotoBooth.add_taken_photo(photo())
  end

  test "defaults" do
    default()
    |> assert_key(:troll, false)
    |> assert_key(:countdown_list, @default_countdown)
  end

  test "the changing of mode" do
    default()
    |> PhotoBooth.change_mode(:countdown)
    |> assert_key(:mode, :countdown)
  end

  test "countdown" do
    default()
    |> PhotoBooth.countdown()
    |> assert_key(:countdown_list, [{2,1000}, {1,1000}])
    |> PhotoBooth.countdown()
    |> assert_key(:countdown_list, [{1,1000}])
    |> PhotoBooth.countdown()
    |> assert_key(:countdown_list, [])
  end

  test "countdown full" do
    default()
    |> PhotoBooth.countdown()
    |> PhotoBooth.countdown()
    |> PhotoBooth.countdown()
    |> assert_key(:countdown_list, [])
    |> PhotoBooth.countdown()
    |> assert_key(:countdown_list, @default_countdown)
    |> assert_key(:mode, :shooting)
  end
  
  test "make countdown" do
    expected = [{6, 1000}, {5, 1000}, {4, 1000}, {3, 1000}, {2, 1000}, {1, 1000}]

    assert PhotoBooth.make_countdown(6) == expected
  end

  test "take pictures" do
    default()
    |> PhotoBooth.add_taken_photo(photo())
    |> PhotoBooth.add_taken_photo(photo())
    |> PhotoBooth.add_taken_photo(photo())
    |> assert_key(:photos, [photo(), photo(), photo()])
    |> assert_key(:taken, 3)
  end

  test "advancing the mode back to countdown" do
    default()
    |> PhotoBooth.change_mode(:shooting)
    |> PhotoBooth.advance_from_shooting()
    |> assert_key(:mode, :countdown)
  end

  test "advancing the mode to the selection process" do
    full()
    |> assert_key(:mode, :choosing)
  end

  test "start choosing mode" do
    full()
    |> PhotoBooth.choose(:accept)
    |> assert_key(:mode, :choosing)
  end

  test "almost empty choosing mode" do
    almost_empty()
    |> PhotoBooth.choose(:reject)
    |> assert_key(:mode, :transmitting)
  end

  test "proper finish" do
    almost_empty()
    |> PhotoBooth.choose(:accept)
    |> PhotoBooth.finish
    |> PhotoBooth.start
    |> assert_key(:countdown_list, @default_countdown)
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
