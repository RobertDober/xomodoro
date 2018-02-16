defmodule XomodoroTest do
  use ExUnit.Case
  doctest Xomodoro

  test "greets the world" do
    assert Xomodoro.hello() == :world
  end
end
