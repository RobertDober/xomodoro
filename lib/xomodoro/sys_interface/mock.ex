defmodule Xomodoro.SysInterface.Mock do
  # Should probably in a location where we can it
  # exclude from the file path for the prod env, `test/support` ?
  @behaviour Xomodoro.SysInterface.Behavior


  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end


  def clear do
    Agent.update(__MODULE__, fn _ -> [] end)
  end

  @spec sleep( number ) :: :ok
  def sleep time do
    Agent.update(__MODULE__, fn messages -> [{:sleep, time} | messages] end)
    :ok
  end

  @spec cmd( String.t, list(String.t) ) :: {String.t, non_neg_integer()} 
  def cmd command, args do
    Agent.update(__MODULE__, fn messages -> [{:cmd, {command, args}} | messages] end)
    {"test", 0}
  end

end
