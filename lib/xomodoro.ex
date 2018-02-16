defmodule Xomodoro do

  alias Xomodoro.Runner

  @moduledoc """
  Sends pomodoro timer events to tmux sessions
  """

  def main(args) do
    args |> parse_args() |> interpret()
  end


  defp interpret( {[{:help, true}|_], _positional, []} ) do
    usage()
  end
  defp interpret( {kwd, positional, []} ) do
    time = Keyword.get(kwd, :time, "25")
    {time1, _} = Integer.parse( time )
    Runner.run( positional, time1 )
  end 
  defp interpret( {_kwds, _positional, errors} ) do
    IO.puts :stderr, "Illegal options #{inspect errors}"
    usage()
  end


  defp parse_args(args) do
    OptionParser.parse(args, strict: switches(), aliases: aliases())
  end

  defp switches,
    do: [
      time: :number,
      help: :boolean,
    ]

  defp aliases, do: [t: :time, h: :help]

  @usage """
    xomodoro [-t|--time <minutes>] <session_list>

    Sends pomodoro events to all indicated sessions
  """
  defp usage() do
    IO.puts :stderr, @usage
  end
end
