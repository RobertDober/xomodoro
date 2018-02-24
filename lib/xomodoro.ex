defmodule Xomodoro do

  use Xomodoro.Types

  alias Xomodoro.Options
  alias Xomodoro.Runner

  @moduledoc """
  Sends pomodoro timer events to tmux sessions
  """

  @spec main(OptionParser.argv()) :: status()
  def main(args) do
    args
    |> Options.parse()
    |> interpret()
  end


  @spec interpret(Options.result_t()) :: status()
  defp interpret( {:error, reason} ) do
    IO.puts :stderr, reason
    usage()
  end
  defp interpret( {:ok, {options, positionals}} ) do
     interpret_ok(options, positionals)
  end

  @spec interpret_ok( Options.t, Options.positional_args_t() ) :: :ok
  defp interpret_ok( %{help: true}, _ ) do
    usage()
    :ok
  end
  defp interpret_ok( %{version: true}, _ ) do
    with {:ok, version} = :application.get_key(:xomodoro, :vsn) do
      IO.puts version
      :ok
    end
  end
  defp interpret_ok( options, session_names ) do
    Runner.run( session_names, options )
  end 


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
