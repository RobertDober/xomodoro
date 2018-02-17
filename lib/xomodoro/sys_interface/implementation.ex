defmodule Xomodoro.SysInterface.Implementation do
  @behaviour Xomodoro.SysInterface.Behavior

  def sleep time do
    Process.sleep time
  end

  def cmd command, args do
    System.cmd(command, args)
  end
end
