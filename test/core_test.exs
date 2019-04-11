defmodule CoreTest do
  use ExUnit.Case
  alias Pex.Core.PhotoBooth

  def default(), do: PhotoBooth.new

  def full() do
  PhotoBooth.new
  |> PhotoBooth.take_picture(<<>>)
  |> PhotoBooth.take_picture(<<>>)
  |> PhotoBooth.take_picture(<<>>)
  |> PhotoBooth.take_picture(<<>>)
  |> PhotoBooth.take_picture(<<>>)
  end

  test "test defaults" do
    assert default().troll == false
    assert default().count_down == 3
  end

  test "test the changing of mode" do
    booth = default()
    |> PhotoBooth.change_mode(:countdown)
    assert booth.mode == :countdown
  end

  test "test countdown" do
  booth = default()
  |> PhotoBooth.countdown()
  |> PhotoBooth.countdown()
  |> PhotoBooth.countdown()
  assert booth.count_down() == 0
  end

  test "test countdown full" do
  booth = default()
  |> PhotoBooth.countdown()
  |> PhotoBooth.countdown()
  |> PhotoBooth.countdown()
  |> PhotoBooth.countdown()
  assert booth.count_down() == 3
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
  |> PhotoBooth.advance()
  assert booth.mode == :countdown
  end

  test "test advancing the mode to the selection process" do
  booth = full()
  assert booth.mode == :choose
  end

end
