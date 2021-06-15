defmodule ViaUtilsTest do
  use ExUnit.Case
  doctest ViaUtils

  test "greets the world" do
    assert ViaUtils.hello() == :world
  end
end
