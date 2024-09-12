defmodule RandomPasswordGeneratorTest do
  use ExUnit.Case
  doctest RandomPasswordGenerator

  test "greets the world" do
    assert RandomPasswordGenerator.hello() == :world
  end
end
