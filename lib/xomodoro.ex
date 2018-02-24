defmodule Xomodoro do

  use Xomodoro.Types

  alias Xomodoro.Runner

  @moduledoc """
  Sends pomodoro timer events to tmux sessions
  """

  @spec main(OptionParser.argv()) :: status()
  def main(args) do
    args |> parse_args() |> interpret()
  end


  @spec interpret( parsed_options() ) :: status()
  defp interpret( {[{:help, true}|_], _positional, []} ) do
    usage()
  end
  defp interpret( {[{:palette, _}|_], _positional, []} ) do
    IO.puts :stderr, "The palette option is not implemented yet"
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

  @spec parse_args( OptionParser.argv() ) :: parsed_options()
  defp parse_args(args) do
    OptionParser.parse(args, strict: switches(), aliases: aliases())
  end

  @spec switches() :: Keyword.t()
  defp switches,
    do: [
      palette: :string,
      time: :number,
      help: :boolean,
    ]

  @spec aliases() :: Keyword.t()
  defp aliases, do: [p: :palette, t: :time, h: :help]

  @usage """
    xomodoro [-t|--time <minutes>] [-p|--palette <color-palette>] <session_list>

    Sends pomodoro events to all indicated sessions, or the current session if no other session is indicated

    Options:
       --time defaults to 25
       time in minutes for the pomodoro timer to be set to initially.

       --palette color palette to be used to in the events shown in the left status of the tmux sessions
       not yet implemented yet, fixed to green on dark

    Details:

      The xomodoro escript shows the current pomodoro time countdown in the left status of all inidicated sessions.
      At 5 minutes (not configurable yet), the color change and when the timer expires the color changes yet again.

      After expiration the escript asks you to finish the pomodoro and reset the left status.

    Caveats:

      Interrupting the escript does not reset the left status (yet?).

  """
  @spec usage() :: :error
  defp usage() do
    IO.puts :stderr, @usage
    :error
  end
end
