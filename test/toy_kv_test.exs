defmodule ToyKVTest do
  use ExUnit.Case
  doctest ToyKV

  test "greets the world" do
    assert ToyKV.hello() == :world
  end
end
