# Xomodoro


An Elixir escript to send Pomodoro Events to tmux sessions


## Installation

Because of the very specialised behavior of this escript it is not deployed as a hex package.

Clone or download this repro and run

*  `mix escript.build`

*  `mix escript.install` if you wish so


## Usage

     xomodoro --help`


     xomodoro [-t|--time <minutes>] [-p|--palette <color-palette>] <session_list>

      Sends pomodoro events to all indicated sessions, or the current session if no other session is indicated

      Options:
         --time defaults to 25
         time in minutes for the pomodoro timer to be set to initially.

         --palette color palette to be used to in the events shown in the left status of the tmux sessions
         not yet implemented yet, fixed to green on dark

      Details:

        The xomodoro escript shows the current pomodoro time countdown in the left status of all inidicated sessions.
        At 5 minutes (not configurable yet), the color change and when the timer expires the color changes yet again.

        After expiration the escript asks you to finish the pomodoro and reset the left status.

      Caveats:

        Interrupting the escript does not reset the left status (yet?). Workaround bystart again for the same sessions with
        time th 0 and hit enter.

        The original text of the left status is globbered, "Session: session_name" is assumed.




# LICENSE

Apache 2 (c.f. LICENSE)

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/xomodoro](https://hexdocs.pm/xomodoro).

