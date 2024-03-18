defmodule TraverseTest do
  use ExUnit.Case
  doctest Traverse

  test "greets the world" do
    assert Traverse.hello() == :world
  end
end
