defmodule Xomodoro.TmuxTest do
  use ExUnit.Case

  alias Xomodoro.SysInterface.Mock
  alias Xomodoro.Tmux
  alias Xomodoro.Tmux.SessionStatus

  test "reset_session" do
    Mock.clear

    Tmux.reset_session( %SessionStatus{session_name: "my_session", status_left: "before", status_left_style: "style"} )

    assert Mock.messages == [
      {},
      {}
    ]
  end
end
