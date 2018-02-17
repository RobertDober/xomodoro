defmodule Xomodoro.Tmux.SessionStatus do
  
  defstruct session_name: "", status_left: "", status_left_style: ""

  @type t :: %__MODULE__{session_name: binary(), status_left: binary(), status_left_style: binary()}
  @type ts :: list(t)
end
