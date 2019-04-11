defmodule CoreTest do
  use ExUnit.Case
  alias Pex.Core.PhotoBooth

  def default(), do: PhotoBooth.new

  def full() do
    PhotoBooth.new
    |> PhotoBooth.start
    |> PhotoBooth.take_picture(<<>>)
    |> PhotoBooth.take_picture(<<>>)
    |> PhotoBooth.take_picture(<<>>)
    |> PhotoBooth.take_picture(<<>>)
    |> PhotoBooth.take_picture(<<>>)
  end

  test "test defaults" do
    assert default().troll == false
    assert default().seconds_to_countdown == 3
  end

  test "test the changing of mode" do
    booth = default()
    |> PhotoBooth.change_mode(:countdown)
    assert booth.mode == :countdown
  end

  test "test countdown" do
    booth = default()
    |> PhotoBooth.countdown()
    |> assert_key(:seconds_to_countdown, 2)
    |> PhotoBooth.countdown()
    |> PhotoBooth.countdown()
    |> assert_key(:seconds_to_countdown, 0)
  end

  test "test countdown full" do
    booth = default()
    |> PhotoBooth.countdown()
    |> PhotoBooth.countdown()
    |> PhotoBooth.countdown()
    |> PhotoBooth.countdown()
    assert booth.seconds_to_countdown == 3
    assert booth.mode == :shooting
  end

  test "test take pictures" do
    booth = default()
    |> PhotoBooth.take_picture(<<>>)
    |> PhotoBooth.take_picture(<<>>)
    |> PhotoBooth.take_picture(<<>>)
    assert booth.photos == [<<>>, <<>>, <<>>]
    assert booth.taken == 3
  end

  test "test advancing the mode back to countdown" do
    booth = default()
    |> PhotoBooth.change_mode(:shooting)
    |> PhotoBooth.advance_from_shooting()
    assert booth.mode == :countdown
  end

  test "test advancing the mode to the selection process" do
    booth = full()
    assert booth.mode == :choosing
  end

  test "test functions do not fire unless in appropriate state" do
    booth = full()
    assert PhotoBooth.start(booth) == booth
    assert PhotoBooth.finish(booth) == booth
  end

  test "test start choosing mode" do
    booth = full()
    choices = [1,2,3]
    assert PhotoBooth.choose(booth,choices).mode == :transmitting
  end
  
  test "test proper finish" do
    booth = full()
    choices = [1,2,3]
    
    expected = 
      PhotoBooth.choose(booth,choices)
      |> PhotoBooth.finish
      |> PhotoBooth.start

    assert expected.seconds_to_countdown == 3
    assert expected.taken == 0
    assert expected.photos == []
    assert expected.chosen == []
  end
  
  defp assert_key(booth, key, actual) do
    expected = Map.get(booth, key)
      
    assert expected == actual
    booth
  end
end
