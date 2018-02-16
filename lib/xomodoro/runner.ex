defmodule Xomodoro.Runner do

  alias Xomodoro.Tmux
  @moduledoc """
  Implements the system commands to be sent to all tmux sessions
  """ 

  @doc """
  Entry point
  """
  def run sessions, 0 do
    notify_sessions(sessions, 0)
    finish(sessions)
  end
  def run sessions, time do
    notify_sessions(sessions, time)
    Process.sleep(60_000)
    run(sessions, time - 1)
  end

  defp finish sessions do
    IO.gets "finished?"
    reset_sessions(sessions)
  end

  defp notify_session session, time do
    IO.puts "#{Time.utc_now}> INFO notify session: #{session}, #{time}"
    Tmux.notify_session(session, time)
  end
  defp notify_sessions sessions, time do
    sessions |> Enum.each(&notify_session(&1, time))
  end

  defp reset_session session do
    IO.puts "#{Time.utc_now}> INFO reset session: #{session}"
    Tmux.reset_session(session)
  end
  defp reset_sessions sessions do
    sessions |> Enum.each(&reset_session/1)
  end
end
