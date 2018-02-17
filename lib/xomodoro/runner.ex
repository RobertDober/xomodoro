defmodule Xomodoro.Runner do

  alias Xomodoro.Tmux

  @sys_interface Application.fetch_env!(:xomodoro, :sys_interface)

  @moduledoc """
  Implements the system commands to be sent to all tmux sessions
  """ 

  @doc """
  Entry point
  """
  def run [], time do
    with session <- Tmux.read_session_status(nil), do: _run([session], time)
  end
  def run sessions, time do
    sessions
    |> Enum.map(&Tmux.read_session_status/1)
    |> _run(time)
  end

  defp _run sessions, 0 do
    notify_sessions(sessions, 0)
    finish(sessions)
  end
  defp _run sessions, time do
    notify_sessions(sessions, time)
    @sys_interface.sleep(60_000)
    _run(sessions, time - 1)
  end

  defp finish sessions do
    IO.gets "finished?"
    reset_sessions(sessions)
  end

  defp notify_session session, time do
    IO.puts "#{Time.utc_now}> INFO notify session: #{session.session_name}, #{time}"
    Tmux.notify_session(session, time)
  end
  defp notify_sessions sessions, time do
    sessions |> Enum.each(&notify_session(&1, time))
  end

  defp reset_session session do
    IO.puts "#{Time.utc_now}> INFO reset session: #{session.session_name}"
    Tmux.reset_session(session)
  end
  defp reset_sessions sessions do
    sessions |> Enum.each(&reset_session/1)
  end
end
