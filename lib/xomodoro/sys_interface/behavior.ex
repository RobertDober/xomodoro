defmodule Xomodoro.SysInterface.Behavior do
  defmodule Behavior do
    @callback sleep(number()) :: :ok

    @callback cmd(String.t, list(String.t)) :: {String.t, number()}
  end
end
