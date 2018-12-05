defmodule Xomodoro.Runner do

  use Xomodoro.Types

  alias Xomodoro.Tmux
  alias Xomodoro.Options
  alias Xomodoro.Tmux.SessionStatus

  @sys_interface Application.fetch_env!(:xomodoro, :sys_interface)

  @moduledoc """
  Implements the system commands to be sent to all tmux sessions
  """ 

  @doc """
  Entry point
  """
  @spec run( Options.positional_args_t(), Options.t() ) :: :ok
  def run [], options do
    with {time, _} <- Integer.parse(options.time), do:
      with session <- Tmux.read_session_status(nil, options), do: _run([session], time)
  end
  def run sessions, options do
    with {time, _} <- Integer.parse(options.time) do
      sessions
      |> Enum.map(&Tmux.read_session_status(&1, options))
      |> _run(time)
    end
  end

  @spec _run( SessionStatus.ts(), number() ) :: :ok 
  defp _run sessions, 0 do
    notify_sessions(sessions, 0)
    finish(sessions)
  end
  defp _run sessions, time do
    notify_sessions(sessions, time)
    @sys_interface.sleep(60_000)
    _run(sessions, time - 1)
  end

  @spec finish( SessionStatus.ts() ) :: :ok
  defp finish sessions do
    IO.gets "finished?"
    reset_sessions(sessions)
  end

  @spec notify_session( SessionStatus.t(), number() ) :: String.t()
  defp notify_session session, time do
    IO.puts "#{Time.utc_now}> INFO notify session: #{session.session_name}, #{time}"
    Tmux.notify_session(session, time)
  end
  @spec notify_sessions( SessionStatus.ts(), number() ) :: :ok 
  defp notify_sessions sessions, time do
    sessions |> Enum.each(&notify_session(&1, time))
  end

  @spec reset_session( SessionStatus.t() ) :: String.t()
  defp reset_session session do
    IO.puts "#{Time.utc_now}> INFO reset session: #{session.session_name}"
    Tmux.reset_session(session)
  end
  @spec reset_sessions( SessionStatus.ts() ) :: :ok
  defp reset_sessions sessions do
    sessions |> Enum.each(&reset_session/1)
  end
end
