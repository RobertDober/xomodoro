defmodule Xomodoro.Tmux do
  use Xomodoro.Types

  alias Xomodoro.Options
  alias Xomodoro.Tmux.SessionStatus


  @sys_interface Application.fetch_env!(:xomodoro, :sys_interface)

  @spec notify_session( SessionStatus.t(), number() ) :: String.t()
  def notify_session session, time do
    {fg, bg} = get_style(time)
    set_style(session.session_name, make_style(fg, bg))
    status_left(session.session_name, ~s{#{cleaned_status session.status_left} [#{time}] })
  end

  @spec read_session_status( maybe(String.t()), Options.t() ) :: SessionStatus.t()
  def read_session_status nil, options do
    current_session() |> read_session_status(options)
  end

  def read_session_status session, options do
    %SessionStatus{session_name: session,
                   status_left:  read_status_left(session),
                   status_left_style: read_status_left_style(session),
                   options: options}
  end

  @spec reset_session( SessionStatus.t() ) :: String.t()
  def reset_session session do
    set_style(session.session_name, session.status_left_style)
    status_left(session.session_name, session.status_left)
  end


  ##################################################################
  #
  #  Privates
  #
  ##################################################################

  @spec cleaned_status( String.t() ) :: String.t()
  defp cleaned_status status do
    status
    |> String.replace( ~r{\s\z}, "" )
    |> String.replace( ~r{\s\[\d+\]\s*\z}, "" )
  end

  @spec current_session() :: String.t()
  defp current_session do
    tmux(["list-panes", "-F", "\#{session_name}"]) |> String.trim()
  end

  defp default_status status, session do
    if String.trim(status) == "" do
      "Session: #{session}"
    else
      status
    end
  end
  @spec get_style( number() ) :: pair( String.t() )
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

  @spec make_style( String.t(), String.t() ) ::  String.t()
  defp make_style fg, bg do
    ~s{fg=#{fg},bg=#{bg}}
  end

  @spec read_status_left( String.t() ) :: String.t()
  def read_status_left session do
    tmux_show_option(session, "status-left")
    |> default_status(session)
  end

  @spec read_status_left_style( String.t() ) :: String.t()
  def read_status_left_style session do
    tmux_show_option(session, "status-left-style")
  end

  @spec set_style( String.t(), String.t() ) :: String.t()
  defp set_style(session, style) do
    tmux_set(session, ["status-left-style", style])
  end

  @spec status_left( String.t(), String.t() ) :: String.t()
  defp status_left session, text do
    tmux_set(session, ["status-left", text])
  end

  @spec tmux( list(String.t()) ) :: String.t()
  defp tmux args do
    with {output, 0} <- @sys_interface.cmd("tmux", args), do: output
  end

  @spec tmux_set( String.t(), list(String.t()) ) :: String.t()
  defp tmux_set session, args do
    tmux([ "set", "-t", session | args])
  end

  @spec tmux_show_option( String.t(), String.t() ) :: String.t()
  defp tmux_show_option session, option do
    tmux(["show-options", "-t", session, option])
    |> String.trim()
    |> String.replace("#{option} " , "")
    |> String.replace(~r{\A"}, "")
    |> String.replace(~r{"\z}, "")
  end

end
