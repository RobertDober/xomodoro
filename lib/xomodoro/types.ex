defmodule Xomodoro.Types do
  
  defmacro __using__( _options) do
    quote do

      @type either(t) :: {:ok, t} | {:error, String.t}

      @type pair(t)  :: {t, t}
      @type pair(t, u)  :: {t, u}

      @type status :: :ok | :error

      @type cmd_return :: pair( binary(), non_neg_integer())

      @type parsed_options_t :: { OptionParser.parsed(), OptionParser.argv(), OptionParser.errors() }

      @type maybe(t) :: t | nil

    end
  end
end
