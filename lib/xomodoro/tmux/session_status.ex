defmodule Xomodoro.Tmux.SessionStatus do

  alias Xomodoro.Options
  
  defstruct session_name: "", status_left: "", status_left_style: "", options: %Options{}

  @type t :: %__MODULE__{session_name: binary(), status_left: binary(), status_left_style: binary(), options: Options.t()}
  @type ts :: list(t)
end
