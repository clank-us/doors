defmodule DoorsTest do
  use ExUnit.Case
  doctest Doors

  test "greets the world" do
    assert Doors.hello() == :world
  end
end
