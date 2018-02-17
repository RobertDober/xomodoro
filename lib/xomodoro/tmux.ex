defmodule Xomodoro.Tmux do
  alias Xomodoro.Tmux.SessionStatus

  @sys_interface Application.fetch_env!(:xomodoro, :sys_interface)

  def notify_session session, time do
    {fg, bg} = get_style(time)
    set_style(session.session_name, make_style(fg, bg))
    status_left(session.session_name, ~s{#{cleaned_status session.status_left} [#{time}] })
  end

  def read_session_status nil do
    current_session() |> read_session_status()
  end

  def read_session_status session do
    %SessionStatus{session_name: session,
                   status_left:  read_status_left(session),
                   status_left_style: read_status_left_style(session)}
  end

  def reset_session session do
    IO.inspect Mix.env
    IO.inspect @sys_interface
    set_style(session.session_name, session.status_left_style)
    status_left(session.session_name, session.status_left)
  end


  ##################################################################
  #
  #  Privates
  #
  ##################################################################

  defp cleaned_status status do
    status
    |> String.replace( ~r{\s*\[\d+\]\s*\z}, "" )
  end

  defp current_session do
    tmux(["list-panes", "-F", "\#{session_name}"]) |> String.trim()
  end

  defp get_style time do
    case time do
      0 -> { "black", "colour196"}
      1 -> { "colour202", "colour19"}
      2 -> { "colour202", "colour19"}
      3 -> { "colour202", "colour19"}
      4 -> { "colour202", "colour19"}
      5 -> { "colour202", "colour19"}
      _ -> { "green", "black"}
    end
  end

  defp make_style fg, bg do
    ~s{fg=#{fg},bg=#{bg}}
  end

  def read_status_left session do
    tmux_show_option(session, "status-left")
  end

  def read_status_left_style session do
    tmux_show_option(session, "status-left-style")
  end

  defp set_style(session, style) do
    tmux_set(session, ["status-left-style", style])
  end

  defp status_left session, text do
    tmux_set session, ["status-left", text]
  end

  defp tmux args do
    with {output, 0} <- @sys_interface.cmd("tmux", args), do: output
  end

  defp tmux_set session, args do
    tmux([ "set", "-t", session | args])
  end

  defp tmux_show_option session, option do
    tmux(["show-options", "-t", session, option])
    |> String.trim()
    |> String.replace("#{option} " , "")
    |> String.replace(~r{\A"}, "")
    |> String.replace(~r{"\z}, "")
  end

end
