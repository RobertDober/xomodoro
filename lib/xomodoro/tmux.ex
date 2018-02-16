defmodule Xomodoro.Tmux do

  def notify_session session, time do
    {fg, bg} = get_style(time)
    set_style(session, fg, bg)
    status_left(session, ~s{Session: #{session} [#{time}] })
  end

  def reset_session session do
    {fg, bg} = get_style(100)
    set_style(session, fg, bg)
    status_left(session, ~s{Session: #{session} })
  end

  defp get_style time do
    case time do
      0 -> { "black", "colour196"}
      1 -> { "colour202", "colour19"}
      2 -> { "colour202", "colour19"}
      3 -> { "colour202", "colour19"}
      4 -> { "colour202", "colour19"}
      5 -> { "colour202", "colour19"}
      _ -> { "white", "black"}
    end
  end

  defp set_style(session, fg, bg) do
    tmux_set session, ["status-left-style", ~s{fg=#{fg},bg=#{bg}}]
  end

  defp status_left session, text do
    tmux_set session, ["status-left", text]
  end


  defp tmux_set session, args do
    "tmux"
    |> System.cmd(["set", "-t", session | args])
  end
end
