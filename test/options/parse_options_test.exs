defmodule Options.ParseOptionsTest do
  use ExUnit.Case

  alias Xomodoro.Options

  describe "options that will eventually run" do
    test "empty args -> default options" do 
      assert Options.parse([]) == {:ok, {%Options{}, []}}
    end
  end

  describe "options that provide information" do 

    test "version" do
      assert Options.parse(~w(--version)) == {:ok, {%Options{version: true}, []}}
    end
    
  end
  
end

