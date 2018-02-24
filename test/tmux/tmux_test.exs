defmodule Xomodoro.TmuxTest do
  use ExUnit.Case

  alias Xomodoro.SysInterface.Mock
  alias Xomodoro.Tmux
  alias Xomodoro.Tmux.SessionStatus

  test "reset_session" do
    Mock.clear

    Tmux.reset_session( mk_session_status( "my_session", "before" ) )

    assert Mock.messages == [
      {:cmd, {"tmux", ["set", "-t", "my_session", "status-left", "before"]}},
      {:cmd, {"tmux", ["set", "-t", "my_session", "status-left-style", "style"]}}
    ]
  end

  test "notify_session first time" do
    Mock.clear

    Tmux.notify_session( mk_session_status( "Spacy", "Session: Spacy " ), 25 )
    assert Mock.messages == [
      {:cmd, {"tmux", ["set", "-t", "Spacy", "status-left", "Session: Spacy [25] "]}},
      {:cmd, {"tmux", ["set", "-t", "Spacy", "status-left-style", "fg=green,bg=black"]}}
    ]
  end

  test "notify_session second time" do
    Mock.clear

    Tmux.notify_session( mk_session_status( "Spacy", "Session: Spacy [25] " ), 24 )
    assert Mock.messages == [
      {:cmd, {"tmux", ["set", "-t", "Spacy", "status-left", "Session: Spacy [24] "]}},
      {:cmd, {"tmux", ["set", "-t", "Spacy", "status-left-style", "fg=green,bg=black"]}}
    ]
  end

  defp mk_session_status name, text, style \\ "style"  do
    %SessionStatus{session_name: name, status_left: text, status_left_style: style}
  end
end
