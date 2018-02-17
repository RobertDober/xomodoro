defmodule Xomodoro.SysInterface.Implementation do
  @behaviour Xomodoro.SysInterface.Behavior

  @spec sleep( number ) :: :ok
  def sleep time do
    Process.sleep time
  end

  @spec cmd( String.t, list(String.t) ) :: {String.t, non_neg_integer()} 
  def cmd command, args do
    System.cmd(command, args)
  end
end
